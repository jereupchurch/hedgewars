/*
* OpenAL Bridge - a simple portable library for OpenAL interface
* Copyright (c) 2009 Vittorio Giovara <vittorio.giovara@gmail.com>
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU Lesser General Public License as published by
* the Free Software Foundation; version 2 of the License
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
*/

#include "openalbridge.h"
#include "globals.h"
#include "al.h"
#include "alc.h"
#include "wrappers.h"
#include "loaders.h"
#include "string.h"

// Sources are points emitting sound, their number is limited, but a single source can play many buffers
// Buffers hold sound data and are unlimited
ALuint *Sources;
ALuint cache_size, cache_index, sources_number;
ALboolean instances_number;
al_sound_t *the_sounds;
ALint cache_pointer;

// Initialize an OpenAL contex and allocate memory space for data and buffers
// It can be called twice to increase the cache size
int openal_init (int memorysize) {
    ALCcontext *context;
    ALCdevice *device;
    int i;
        
    // reuse old context and resize the existing 
    if (openal_ready() == AL_TRUE) {
        cache_size += memorysize;
        fprintf(stderr,"(Bridge Info) - already initialized, resizing cache to %d\n", cache_size);
        the_sounds = (al_sound_t *)Realloc (the_sounds, sizeof(al_sound_t) * cache_size);
        for (i = cache_size - memorysize; i < cache_size; i++) {
            the_sounds[i].filename = NULL;
            the_sounds[i].buffer = -1;
            the_sounds[i].source_index = -1;
            the_sounds[i].stats = 0;
        }
        instances_number++;
        return AL_TRUE;
    }
    
    cache_pointer = 0;
    instances_number++;
    
    // set the memory dimentsion and the increment width when reallocating
    if (memorysize <= 0)
        cache_size = 50;
    else
        cache_size = memorysize;

    // open hardware device if present
    device = alcOpenDevice(NULL);
    sources_number = 16;
    if (device == NULL) {
        fprintf(stderr,"(Bridge Warning) - failed to open sound device, using software renderer\n");
        device = alcOpenDevice("Generic Software");
        sources_number = 32;
        if (device == NULL) {
            fprintf(stderr,"(Bridge ERROR) - failed to start software renderer, sound will be disabled\n");
            return -1;
        }
    }

    fprintf(stderr,"(Bridge Info) - output device: %s\n", alcGetString(device, ALC_DEVICE_SPECIFIER));

    context = alcCreateContext(device, NULL);
    alcMakeContextCurrent(context);
    alcProcessContext(context);

    if (AL_NO_ERROR != alGetError()) {
        fprintf(stderr,"(Bridge ERROR) - Failed to create a new contex\n");
        alcMakeContextCurrent(NULL);
        alcDestroyContext(context);
        alcCloseDevice(device);
        return -2;
    }

    Sources = (ALuint *)Malloc (sizeof(ALuint) * sources_number);
    alGenSources(sources_number, Sources);
    
    // set the listener gain, position (on xyz axes), velocity (one value for each axe) and orientation
    // Position, Velocity and Orientation of the listener
    ALfloat ListenerPos[] = {0.0, 0.0, 0.0};
    ALfloat ListenerVel[] = {0.0, 0.0, 0.0};
    ALfloat ListenerOri[] = {0.0, 0.0, -1.0, 0.0, 1.0, 0.0};

    alListenerf (AL_GAIN,        1.0f       );
    alListenerfv(AL_POSITION,    ListenerPos);
    alListenerfv(AL_VELOCITY,    ListenerVel);
    alListenerfv(AL_ORIENTATION, ListenerOri);

    if (AL_NO_ERROR != alGetError()) {
        fprintf(stderr,"(Bridge ERROR) - Failed to set Listener properties\n");
        return -3;
    }

    the_sounds = (al_sound_t *)Malloc (sizeof(al_sound_t) * cache_size);
    for (i = 0; i < cache_size; i++) {
        the_sounds[i].filename = NULL;
        the_sounds[i].buffer = -1;
        the_sounds[i].source_index = -1;
        the_sounds[i].stats = 0;
    }

    alGetError();
    return AL_TRUE;
}


// Stop all sounds, deallocate all memory and close OpenAL context
void openal_close (void) {
    ALCcontext *context;
    ALCdevice  *device;
    int i;
    
    if (instances_number == 0) {
        fprintf(stderr,"(Bridge Warning) - OpenAL not initialized\n");
        return;
    }

    instances_number--;
    if (instances_number > 0) {
        return;
    }
    
    //TODO: free other stuff also
    for (i = 0; i < cache_size; i++)
        alDeleteBuffers (1, &the_sounds[i].buffer);
    free(the_sounds);

    alSourceStopv	(sources_number, Sources);
    alDeleteSources (sources_number, Sources);

    free(Sources);

    context = alcGetCurrentContext();
    device  = alcGetContextsDevice(context);

    alcMakeContextCurrent(NULL);
    alcDestroyContext(context);
    alcCloseDevice(device);

    fprintf(stderr,"(Bridge Info) - closed\n");

    return;
}


ALboolean openal_ready (void) {
    if (instances_number >= 1) 
        return AL_TRUE;
    else
        return AL_FALSE;
}


// Open a file, load into memory and allocate the Source buffer for playing
int openal_loadfile (const char *filename){
    ALenum format, error;
    ALsizei bitsize, freq;
    uint32_t fileformat;
    al_sound_t soundData;
    int len, i;
    char *data;
    FILE *fp;
    
    if (openal_ready() == AL_FALSE) {
        fprintf(stderr,"(Bridge Warning) - not initialized\n");
        return -1;
    }
    
    // if this sound is already loaded return the index from the_sounds
    len = strlen(filename);
    for (i = 0; i < cache_size; i++) {
        if (the_sounds[i].filename != NULL && strncmp(the_sounds[i].filename, filename, len) == 0) {
#ifdef DEBUG
            fprintf(stderr,"(Bridge Debug) - sound %d is already loaded\n", i);
#endif
            return i;
        }
    }

    if (cache_pointer >= cache_size) {
        fprintf(stderr,"(Bridge ERROR) - Cache size limit reached; consider allocating more space\n", filename);
        return -2;
    }
    
    // detect the file format, as written in the first 4 bytes of the header
    fp = Fopen (filename, "rb");

    if (fp == NULL) {
        fprintf(stderr,"(Bridge ERROR) - File %s not loaded\n", filename);
        return -3;
    }

    error = fread (&fileformat, sizeof(uint32_t), 1, fp);
    fclose (fp);

    if (error < 0) {
        fprintf(stderr,"(Bridge ERROR) - File %s is too short\n", filename);
        return -4;
    }

    switch (ENDIAN_BIG_32(fileformat)) {
        case OGG_FILE_FORMAT:
            error = load_oggvorbis (filename, &format, &data, &bitsize, &freq);
            break;
        case WAV_FILE_FORMAT:
            error = load_wavpcm (filename, &format, &data, &bitsize, &freq);
            break;
        default:
            fprintf(stderr,"(Bridge ERROR) - File format (%08X) not supported\n", ENDIAN_BIG_32(fileformat));
            return -5;
            break;
    }

    if (error != 0) {
        fprintf(stderr,"(Bridge ERROR) - error loading file %s\n", filename);
        free(data);
        return -6;
    }

    alGenBuffers(1, &soundData.buffer);
    soundData.filename = filename;
    soundData.source_index = -1;
    soundData.stats = 0;
    
    if (AL_NO_ERROR != alGetError()) {
        fprintf(stderr,"(Bridge ERROR) - Failed to allocate memory for buffers\n");
        return -5;
    }
    
    // copy pcm data in one buffer and free it
    alBufferData(soundData.buffer, format, data, bitsize, freq);
    free(data);

    if (AL_NO_ERROR != alGetError()) {
        fprintf(stderr,"(Bridge ERROR) - Failed to write data to buffers\n");
        return -8;
    }
    
    // clear any AL errors beforehand
    alGetError();

    fprintf(stderr,"(Bridge Info) - successfully loaded %s\n", filename);

    // returns the index of the source you just loaded, increments it and exits
    the_sounds[cache_pointer] = soundData;
    return cache_pointer++;
}
