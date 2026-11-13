@rem Adds SURREALIS markers, README entries and module .dme includes
@rem Usage: tools\modularize.bat --tag YOUR_TAG
@rem (--tag can be left out if your branch only touches one modular_tidi module.)
@call "%~dp0\bootstrap\python" "%~dp0\modular_check\modular_check.py" fix --ask %*
@pause
