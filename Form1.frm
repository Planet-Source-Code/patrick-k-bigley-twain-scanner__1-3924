VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "EZTWAIN in Visual Basic"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton Command4 
      Caption         =   "??? Version ???"
      Height          =   255
      Left            =   2760
      TabIndex        =   4
      Top             =   480
      Width           =   1695
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Scan to Clipboard"
      Height          =   255
      Left            =   2760
      TabIndex        =   3
      Top             =   120
      Width           =   1695
   End
   Begin VB.PictureBox Picture1 
      AutoSize        =   -1  'True
      Height          =   1815
      Left            =   0
      ScaleHeight     =   1755
      ScaleWidth      =   3195
      TabIndex        =   2
      Top             =   960
      Width           =   3255
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Select Scanner"
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   2415
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Scan Image"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   480
      Width           =   2415
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()

'You need this Error Trap incase a
'problem occurs
On Error GoTo BadScan

'Before you get past this point, it may be a
'good idea to call a function here, to remove a
'temporary file that amy have been left over
'from a prevoius session.


'Be nice and change the cursor to an Hour Glass,
'Some scanners take too long to load into view.
Screen.MousePointer = 11

'This code will place the scanned image
'at "c:\"  I recommend that you use a special
'coding to find the Windows directory
'and place the file there. You have a better
'chance of having enough drive space to
'store it.
s% = TWAIN_AcquireToFilename(Me.hWnd, "c:\temp.bmp")


If s% = 0 Then
   'If s% = 0 then everything was a success so far!
   'Here, we load the image into the picture box.
   'It is a good idea to have a sub or function that
   'will test the image to make sure it is valid. I would load the image
   'into an invisible image box with an error trap. If the image loads
   'without error, I clear the box and load it into the
   'picture box. (The Image control uses less memory)
   Picture1.Picture = LoadPicture("c:\temp.bmp")

   'We now can delete the temporary BMP file.
   Kill "c:\temp.bmp"

Else
   'If s% did not = 0 then
   'the user cancled the scan, or some other factor
   'such as not enough drive space, etc...
   'We go to our ERROR TRAP below and fix things.
  GoTo BadScan
End If

Screen.MousePointer = 0

'Everything WORKED SO exit the sub!
Exit Sub

BadScan:

'Let the user know that the scanning
'process was not complete.
MsgBox "Scan has been aborted", vbInformation, ""

'IMPORTANT
'Just incase, we should delete the temporary image.
'This is a good place to call a function to do that.
'Remember to use special coding to verify
'a file's existance.

Screen.MousePointer = 0
End Sub

Private Sub Command2_Click()
'A user may have more than one
'scanning device. The code below will
'allow the user to select one.

 TWAIN_SelectImageSource (Me.hWnd)
End Sub

Private Sub Command3_Click()

'Clear the clipboard, most
'scanned images are huge
Clipboard.Clear

'This code explains itself...
    If TWAIN_AcquireToClipboard(Me.hWnd, nPixTypes) = 0 Then MsgBox "No image was acquired or transfer to the clipboard failed.", vbInformation, ""

End Sub

Private Sub Command4_Click()
    MsgBox ("VB Sample Application for EZTWAIN" + vbCrLf + vbCrLf + "eztwain dll reports version" + Str(TWAIN_EasyVersion() / 100) + vbCrLf + "TWAIN Services: " + IIf(TWAIN_IsAvailable() = 0, "Not Available", "") + "Available")

End Sub


