' w32DownloadUnzip.vbs
'   Download a zipfile and uncompress it with no external tools in Windows
'
' Copyright (c) 2012, Vittorio Giovara, <vittorio.giovara@gmail.com>
' Redistribution and use is allowed according to the terms of the BSD license.
'
' References
'   http://superuser.com/questions/59465/is-it-possible-to-download-using-the-windows-command-line
'   http://stackoverflow.com/questions/1021557/how-to-unzip-a-file-using-the-command-line

Set ArgObj = WScript.Arguments

If (Wscript.Arguments.Count = 1) Then
    strFileURL = ArgObj(0)
    strOutputPath = CreateObject("Scripting.FileSystemObject").GetAbsolutePathName(".")
Else
    If (Wscript.Arguments.Count = 2) Then
        strFileURL = ArgObj(0)
        strOutputPath = ArgObj(1)
    Else
        WScript.Echo ("Usage: csript.exe w32DownloadUnzip.vbs url output")
        WScript.Quit
    End if
End if

strHDLocation = "C:\Windows\Temp\temp.zip"

' Fetch the file
Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP")
objXMLHTTP.open "GET", strFileURL, false
objXMLHTTP.send()

If objXMLHTTP.Status = 200 Then
    WScript.Echo ( "Downloading file from " & strFileURL)
    Set objADOStream = CreateObject("ADODB.Stream")
    objADOStream.Open
    objADOStream.Type = 1 'adTypeBinary

    objADOStream.Write objXMLHTTP.ResponseBody
    objADOStream.Position = 0    'Set the stream position to the start

    Set objFSO = Createobject("Scripting.FileSystemObject")
    If objFSO.Fileexists(strHDLocation) Then objFSO.DeleteFile strHDLocation
    Set objFSO = Nothing

    objADOStream.SaveToFile strHDLocation
    objADOStream.Close
    Set objADOStream = Nothing
Else
    WScript.Echo ("Error downloading file (error code: " & objXMLHTTP.Status & ")")
    Set objXMLHTTP = Nothing
    WScript.Quit
End if
Set objXMLHTTP = Nothing

WScript.Echo ( "Extracting file to " & strOutputPath)
Set objShell = CreateObject( "Shell.Application" )
Set objSource = objShell.NameSpace(strHDLocation).Items()
Set objTarget = objShell.NameSpace(strOutputPath)
intOptions = 16 'no user prompt
objTarget.CopyHere objSource, intOptions

WScript.Echo ( "Extraction successful" )
Set objShell = Nothing
