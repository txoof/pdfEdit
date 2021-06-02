# pdfEdit

## **Consider switching to Sedja Desktop**
https://www.sejda.com/desktop

Edits individual MAP reports into a single file ready for Alert Solutions in PowerSchool.

Alert Solutions can read a large PDF file containing information on multiple students and parse that file into individual emails. To distinguish one record from the next Alert Solutions looks for the following text (exactly and with absolutely no flexibility) where XXXXXX is the student number:
      `StudentID:XXXXXX`
     
This script searches individual MAP test results in PDF Format or the line "Student ID: XXXXXX" and replaces it with the Alert Soluitons expectation and then combines the edited PDFs into a single large PDF file that Alert Solutions can use.

Command line usage:
------------------
      $] pdfEdit.sh doc1.pdf doc2.pdf doc3.pdf
      $] pdfEdit.sh /path/to/*.pdf
      
An edited and combined version will be placed on the Desktop (Mac)

GUI Usage:
----------
A platypus wrapped GUI version for the Mac can be found in the mapEdit.app.zip file. 

  Platypus GUI Version:
      Drag and drop multiple MAP pdf files into the window. An edited and combined version will be placed on the Desktop (Mac)

Requirements:
-------------
  * bash/posix environment (written for OS X)
      - sed
  * qpdf 
      - must be available in $PATH (drag and drop expects /usr/local/bin/qpdf); learn more about QPDF: http://qpdf.sourceforge.net/
      - qpdf can be installed on the Mac using HomeBrew https://brew.sh/
