del /q /f "%WINDIR%\System32\OEMDefaultAssociations.xml"

@echo OFF
for /f "usebackq tokens=2 delims=\" %%A in (`reg query "HKEY_USERS" ^| findstr /r /x /c:"HKEY_USERS\\S-.*" /c:"HKEY_USERS\\AME_UserHive_[^_]*"`) do (
	REM If the "Volatile Environment" key exists, that means it is a proper user. Built in accounts/SIDs don't have this key.
	reg query "HKU\%%A" | findstr /c:"Volatile Environment" /c:"AME_UserHive_" > NUL 2>&1
		if not errorlevel 1 (
			PowerShell -NoP -ExecutionPolicy Bypass -File assoc.ps1 "Placeholder" "%%A" ".3fr:nomacs.3fr.3" ".avifs:nomacs.avifs.3" ".bmp:nomacs.bmp.3" ".cur:nomacs.cur.3" ".dcx:nomacs.dcx.3" ".drif:nomacs.drif.3" ".exif:nomacs.exif.3" ".heif:nomacs.heif.3" ".heifs:nomacs.heifs.3" ".icns:nomacs.icns.3" ".iiq:nomacs.iiq.3" ".jp2:nomacs.jp2.3" ".jpf:nomacs.jp2.3" ".jpg:nomacs.jpg.3" ".jpeg:nomacs.jpg.3" ".jps:nomacs.jps.3" ".mng:nomacs.mng.3" ".mos:nomacs.mos.3" ".mpo:nomacs.mpo.3" ".pbm:nomacs.pbm.3" ".pcx:nomacs.pcx.3" ".pgm:nomacs.pgm.3" ".png:nomacs.png.3" ".pns:nomacs.pns.3" ".ppm:nomacs.ppm.3" ".psb:nomacs.psb.3" ".psd:nomacs.psd.3" ".raf:nomacs.raf.3" ".roh:nomacs.roh.3" ".svg:nomacs.svg.3" ".tga:nomacs.tga.3" ".tif:nomacs.tif.3" ".vec:nomacs.vec.3" ".wbmp:nomacs.wbmp.3" ".webp:nomacs.webp.3" ".x3f:nomacs.x3f.3" ".xbm:nomacs.xbm.3" ".xpm:nomacs.xpm.3" ".xml:txtfilelegacy"
	)
)