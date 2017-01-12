call ..\..\utilities\findMatlab.bat
if %ismatlab%==1 (
  start "Matlab" /b %matexe% -r "echoServer_skel;quit;" %matopts%
) else (
  echo runGame;quit; | %matexe% %matopts%
)