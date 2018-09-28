# pdfEdit
edits individual MAP reports into a single file ready for AlertSolutions in PowerSchool
  The script (mapEdit.sh) 

  command line usage:
      pdfEdit.sh doc1.pdf doc2.pdf doc3.pdf
      pdfEdit.sh /path/to/*.pdf
      
  An edited and combined version will be placed on the Desktop (Mac)

A platypus wrapped GUI version for the Mac can be found in the mapEdit.app.zip file. 

  Platypus GUI Version:
      Drag and drop multiple MAP pdf files into the window. An edited and combined version will be placed on the Desktop (Mac)

Requirements:
  qpdf available in $PATH (drag and drop expects /usr/local/bin/)
  learn more about QPDF: http://qpdf.sourceforge.net/
  
  qpdf can be installed on the Mac using HomeBrew 
  https://brew.sh/
