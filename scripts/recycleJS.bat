1>1/* :
	@echo off
	cscript //E:JScript //Nologo "%~f0" %*
	exit /b %errorlevel%
*/

var args = WScript.Arguments

if (args.Length < 1) {
  WScript.Echo("No argument no action.")
  help()
  WScript.Quit(1)
}

var FSO = new ActiveXObject("Scripting.FileSystemObject")

if (FSO.FileExists(args(0))) {
  var objTgt = FSO.GetFile(args(0))
} else if (FSO.FolderExists(args(0))) {
  var objTgt = FSO.GetFolder(args(0))
} else {
  WScript.Echo(args(0) + ' not found')
  WScript.Quit(2)
}

var objShell = new ActiveXObject("Shell.Application")
var objFolder = objShell.NameSpace(objTgt.ParentFolder.Path)
var objItem = objFolder.ParseName(objTgt.Name)

// debug: View verbs if '-v' is given as the second argument.
if (args.Length > 1 && args(1) === '-v') {
  var verbs = objItem.Verbs()
  if (verbs != null) {
    for (var i = 0; i < verbs.Count; i++) {
      WScript.Echo('' + i + ': ' + verbs.Item(i))
    }
  }	
}

objItem.InvokeVerb('delete')

function help() {
  WScript.Echo("Usage:\n\t" + WScript.ScriptName + " <file|folder>")
}

/*
 * Reference: Shell.NameSpace method
 * https://msdn.microsoft.com/en-us/library/windows/desktop/bb774085(v=vs.85).aspx
 * Reference: Folder object
 * https://msdn.microsoft.com/en-us/library/windows/desktop/bb787868(v=vs.85).aspx
 * Reference: FolderItem object
 * https://msdn.microsoft.com/en-us/library/windows/desktop/bb787810(v=vs.85).aspx
 * Reference: FolderItem.Verbs method
 * https://msdn.microsoft.com/en-us/library/windows/desktop/bb787850(v=vs.85).aspx
 * Reference: FolderItemVerbs object
 * https://msdn.microsoft.com/en-us/library/windows/desktop/bb774160(v=vs.85).aspx
 * Reference: FolderItem.InvokeVerb method
 * https://msdn.microsoft.com/en-us/library/windows/desktop/bb787816(v=vs.85).aspx
 * Reference: FolderItemVerb.Doit method
 * https://msdn.microsoft.com/en-us/library/windows/desktop/bb774170(v=vs.85).aspx
 */
