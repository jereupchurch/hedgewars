/*
 * Hedgewars, a free turn based strategy game
 * Copyright (c) 2012 Vittorio Giovara <vittorio.giovara@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
 */

#include "HWApplication.h"
#include <QFileOpenEvent>

#include "hwform.h"
#include "MessageDialog.h"
#include "signal.h"


#if !defined(Q_WS_WIN)
void terminateFrontend(int signal)
{
    Q_UNUSED(signal);
    QCoreApplication::exit(0);
}
#endif

HWApplication::HWApplication(int &argc,  char **argv):
    QApplication(argc, argv)
{
#if !defined(Q_WS_WIN)
    signal(SIGINT, &terminateFrontend);
#endif
#if 0
    qDebug("%s called with", argv[0]);
    for (int i = 1; i < argc; i++)
        qDebug("%d: %s", i, argv[i]);
#endif
}

bool HWApplication::event(QEvent *event)
{
    QFileOpenEvent *openEvent;
    QString scheme, path;

    if (event->type() == QEvent::FileOpen) {
        openEvent = (QFileOpenEvent *)event;
        scheme = openEvent->url().scheme();
        path = openEvent->url().path();

        QFile file(path);
        if (scheme == "file" && file.exists()) {
            form->PlayDemoQuick(openEvent->file());
            return true;
        } else {
            const QString errmsg = tr("Not yet implemented").arg(path);
            MessageDialog::ShowErrorMessage(errmsg, form);
            return false;
        }
     }

    return QApplication::event(event);
}


