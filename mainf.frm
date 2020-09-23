VERSION 5.00
Begin VB.Form mainf 
   BackColor       =   &H00000000&
   Caption         =   "2D WATER"
   ClientHeight    =   8325
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   7680
   LinkTopic       =   "Form1"
   ScaleHeight     =   555
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   512
   StartUpPosition =   1  'CenterOwner
   Begin VB.CheckBox cSMOOTH 
      BackColor       =   &H00000000&
      Caption         =   "Smoother"
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00C0FFC0&
      Height          =   255
      Left            =   3480
      TabIndex        =   7
      Top             =   960
      Width           =   2175
   End
   Begin VB.TextBox Text1 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00C0FFC0&
      Height          =   975
      Left            =   3480
      MultiLine       =   -1  'True
      TabIndex        =   6
      Top             =   0
      Width           =   4095
   End
   Begin VB.HScrollBar wDENS 
      Height          =   255
      Left            =   120
      Max             =   1000
      Min             =   950
      TabIndex        =   4
      Top             =   960
      Value           =   982
      Width           =   1935
   End
   Begin VB.HScrollBar rFREQ 
      Height          =   255
      Left            =   120
      Max             =   100
      Min             =   1
      TabIndex        =   3
      Top             =   360
      Value           =   25
      Width           =   1935
   End
   Begin VB.CheckBox chRAIN 
      BackColor       =   &H00000000&
      Caption         =   "Rain     freq"
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00C0FFC0&
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   120
      Width           =   1935
   End
   Begin VB.CommandButton Command1 
      Caption         =   "START"
      Height          =   855
      Left            =   2520
      TabIndex        =   1
      Top             =   360
      Width           =   855
   End
   Begin VB.PictureBox PIC 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      FillStyle       =   0  'Solid
      ForeColor       =   &H80000008&
      Height          =   6015
      Left            =   120
      ScaleHeight     =   401
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   497
      TabIndex        =   0
      Top             =   1320
      Width           =   7455
   End
   Begin VB.Label Label1 
      BackColor       =   &H00000000&
      Caption         =   "Density"
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00C0FFC0&
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   720
      Width           =   2295
   End
End
Attribute VB_Name = "mainf"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Author : Roberto Mior
'     reexre@ gmail.com
'
'If you use source code or part of it please cite the author
'
'
Option Explicit

Private P() As Single
Private Pcopia() As Single
Private Enable() As Boolean

Private W As Long
Private H As Long
Private x As Long
Private y As Long
Private V As Single
Private C As Long ' zlong

Private Buff1 As Long
Private Buff2 As Long

Private rX As Long
Private rY As Long
Private rrX As Long
Private rrY As Long

Private rON As Boolean

Private Krange As Single


Private Sub Command1_Click()

Dim R As Integer
Dim L As Integer

Buff1 = 1
Do
    
    Buff1 = 1 - Buff1
    Buff2 = 1 - Buff1
    
    'less smooth
    If cSMOOTH.Value = Unchecked Then
        
        For x = 1 To W - 1
            For y = 1 To H - 1
                
                If Enable(x, y) Then
                    
                    P(x, y, Buff1) = (P(x - 1, y, Buff2) + _
                            P(x + 1, y, Buff2) + _
                            P(x, y - 1, Buff2) + _
                            P(x, y + 1, Buff2)) / 2 - P(x, y, Buff1)
                    
                    P(x, y, Buff1) = P(x, y, Buff1) * wDENS / 1000 '0.985
                    
                    V = P(x, y, Buff1)
                    
                    If V < minWH Then V = minWH '- V
                    If V > maxWH Then V = maxWH '- V
                    
                    '                If V <> 128 Then MySetPixel PIC.hdc, x, y, V
                    MySetPixel PIC.hdc, x, y, V
                Else
                    
                    MySetPixel PIC.hdc, x, y, maxWH
                    
                End If
                
                
            Next y
            
        Next x
    Else ' MORE smooth
        
        For x = 1 To W - 1
            For y = 1 To H - 1
                
                If Enable(x, y) Then
                    
                    'more smooth
                    P(x, y, Buff1) = (P(x - 1, y, Buff2) + _
                            P(x + 1, y, Buff2) + _
                            P(x, y - 1, Buff2) + _
                            P(x, y + 1, Buff2) + _
                            P(x - 1, y - 1, Buff2) + _
                            P(x + 1, y - 1, Buff2) + _
                            P(x - 1, y + 1, Buff2) + _
                            P(x + 1, y + 1, Buff2)) / 4 - P(x, y, Buff1)
                    
                    P(x, y, Buff1) = P(x, y, Buff1) * wDENS / 1000 '0.985
                    
                    V = P(x, y, Buff1)
                    
                    If V < minWH Then V = minWH '- V
                    If V > maxWH Then V = maxWH '- V
                    
                    '                If V <> 128 Then MySetPixel PIC.hdc, x, y, V
                    MySetPixel PIC.hdc, x, y, V
                Else
                    
                    MySetPixel PIC.hdc, x, y, maxWH
                    
                End If
                
                
            Next y
            
        Next x
    End If
    
    DoEvents
    
    '''''''''Rain
    If chRAIN.Value = Checked Then
        If Rnd < rFREQ.Value / 100 Then
            x = Int(Rnd * W)
            y = Int(Rnd * H)
            
            If Enable(x, y) Then P(x, y, Buff2) = P(x, y, Buff2) - maxWH * 0.5 - Rnd * maxWH * 0.5
            If Enable(x + 1, y) Then P(x + 1, y, Buff2) = P(x + 1, y, Buff2) - maxWH * 0.5 - Rnd * maxWH * 0.5
            If Enable(x + 1, y + 1) Then P(x + 1, y + 1, Buff2) = P(x + 1, y + 1, Buff2) - maxWH * 0.5 - Rnd * maxWH * 0.5
            If Enable(x, y + 1) Then P(x, y + 1, Buff2) = P(x, y + 1, Buff2) - maxWH * 0.5 - Rnd * maxWH * 0.5
            
        End If
        
    End If
    ''''''''''''''''''''''''
    
    ''''''
    'rubinetto 'faucet
    If rON Then
        
        R = Rnd * 20
        L = Rnd * 5
        rrX = rX + Int(Cos(R) * L)
        rrY = rY + Int(Sin(R) * L)
        If rrX > 0 And rrX < W - 1 And rrY > 0 And rrY < H - 1 Then
            
            If Enable(rrX, rrY) Then P(rrX, rrY, Buff2) = P(rrX, rrY, Buff2) - maxWH * Rnd * 0.5
            '2*2
            If Enable(rrX + 1, rrY) Then P(rrX + 1, rrY, Buff2) = P(rrX + 1, rrY, Buff2) - maxWH * Rnd * 0.5
            If Enable(rrX, rrY + 1) Then P(rrX, rrY + 1, Buff2) = P(rrX, rrY + 1, Buff2) - maxWH * Rnd * 0.5
            If Enable(rrX + 1, rrY + 1) Then P(rrX + 1, rrY + 1, Buff2) = P(rrX + 1, rrY + 1, Buff2) - maxWH * Rnd * 0.5
            
        End If
        
    End If
    
    
Loop While True

End Sub

Private Sub Form_Load()
Randomize Timer

Dim S As String
S = "Left Mouse Down = jet" & vbCrLf
S = S & "Right Mouse Down inside Pic = Faucet ON" & vbCrLf
S = S & "Right Mouse Down outside Pic = Faucet OFF" & vbCrLf
Text1 = S

'InitBrush 0, 5, 5, 160, 250, 255, minWH, maxWH
InitBrush 2, 2, 160, 170, 250, 255, minWH, maxWH

Krange = 255 / (maxWH - minWH)

W = (PIC.ScaleWidth - 1) / DIV
H = (PIC.ScaleHeight - 1) / DIV

ReDim P(0 To W, 0 To H, 0 To 1)
ReDim Pcopia(0 To W, 0 To H)
ReDim Enable(0 To W, 0 To H)

For x = 0 To W
    For y = 0 To H
        
        P(x, y, 1) = 0
        P(x, y, 0) = 0
        
        Enable(x, y) = True
        
        ''BLOCCO quadro
        If Abs(x - (W / 2) + 9) < 33 Then
            If Abs(y - (H / 2) - 5) < 6 Then
                Enable(x, y) = False
            End If
        End If
        
        'Blocco Tondo
        If Sqr((x - 50) ^ 2 + (y - 25) ^ 2) < 15 Then
            Enable(x, y) = False
        End If
    Next
Next

For x = 0 To W
    Enable(x, 0) = False
    Enable(x, H) = False
    If Rnd < 0.5 Then Enable(x, H - 1) = False: If Rnd < 0.5 Then Enable(x, H - 2) = False
    
    P(x, 0, 0) = 0
    P(x, 0, 1) = 0
    P(x, 1, 0) = 0
    P(x, 1, 1) = 0
    P(x, 2, 0) = 0
    P(x, 2, 1) = 0
    
Next
For y = 0 To H
    Enable(0, y) = False
    Enable(W, y) = False
Next


Enable(75, 75) = False
Enable(75, 77) = False
Enable(75, 79) = False

Enable(35, 75) = False
Enable(35, 76) = False
Enable(35, 77) = False
Enable(35, 78) = False
Enable(35, 79) = False
Enable(35, 80) = False
End Sub

Private Sub Form_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
If Button = 2 Then rON = False

End Sub

Private Sub Form_Terminate()
End
End Sub

Private Sub Form_Unload(Cancel As Integer)
End
End Sub





Private Sub PIC_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
If Button = 2 Then rX = x / DIV: rY = y / DIV: rON = True

If Button = 1 Then
    x = x / DIV - 0.5
    y = y / DIV - 0.5
    
    If Enable(x, y) Then P(x, y, Buff1) = P(x, y, Buff1) - maxWH * 0.5
    '2*2
    If Enable(x + 1, y) Then P(x + 1, y, Buff1) = P(x + 1, y, Buff1) - maxWH * 0.5
    If Enable(x, y + 1) Then P(x, y + 1, Buff1) = P(x, y + 1, Buff1) - maxWH * 0.5
    If Enable(x + 1, y + 1) Then P(x + 1, y + 1, Buff1) = P(x + 1, y + 1, Buff1) - maxWH * 0.5
    
    
End If


End Sub

Private Sub PIC_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
If x < 0 Then Exit Sub
If y < 0 Then Exit Sub
If x > W * DIV Then Exit Sub
If y > H * DIV Then Exit Sub

If Button = 1 Then
    x = x / DIV - 0.5
    y = y / DIV - 0.5
    
    If Enable(x, y) Then P(x, y, Buff2) = P(x, y, Buff2) - maxWH * 0.5
    '2*2
    If Enable(x + 1, y) Then P(x + 1, y, Buff2) = P(x + 1, y, Buff2) - maxWH * 0.5
    If Enable(x, y + 1) Then P(x, y + 1, Buff2) = P(x, y + 1, Buff2) - maxWH * 0.5
    If Enable(x + 1, y + 1) Then P(x + 1, y + 1, Buff2) = P(x + 1, y + 1, Buff2) - maxWH * 0.5
    
End If

End Sub


Private Sub wDENS_Change()
Label1.Caption = "Water Densty : " & 1 - wDENS.Value / 1000

End Sub

