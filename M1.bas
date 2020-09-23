Attribute VB_Name = "M1"
Type tp
    x As Single
    y As Single
End Type


Type tL
    P1 As Long
    P2 As Long
End Type

Private Type RECT2
    X1 As Long
    Y1 As Long
    X2 As Long
    Y2 As Long
End Type

Private Type POINTAPI
    x As Long
    y As Long
End Type

Public BRUSH() As Long
Public Rect As RECT2

Public Const DIV = 4 'decrease this on fast computer
Public Const maxWH = 127
Public Const minWH = -127


Public Declare Function GetPixel Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long) As Long
Public Declare Function SetPixel Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal crColor As Long) As Long
'Public Declare Function SetPixelV Lib "gdi32.dll" (ByVal hDC As Long, ByVal X As Long, ByVal Y As Long, ByVal crColor As Long) As Long
'Public Declare Function SetPixelV Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal crColor As Long) As Long


Public Declare Function StretchBlt Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal nSrcWidth As Long, ByVal nSrcHeight As Long, ByVal dwRop As Long) As Long
Public Declare Function SetStretchBltMode Lib "gdi32" (ByVal hdc As Long, ByVal hStretchMode As Long) As Long

Public Const STRETCHMODE = vbPaletteModeNone 'You can find other modes in the "PaletteModeConstants" section of your Object Browser


Public Declare Function FillRect Lib "user32" (ByVal hdc As Long, lpRect As RECT2, ByVal hBrush As Long) As Long
Public Declare Function CreateSolidBrush Lib "gdi32" (ByVal crColor As Long) As Long


Sub Long2RGB(RGBcol As Long, ByRef R As Byte, ByRef G As Byte, ByRef B As Byte)
R = RGBcol And &HFF ' set red
G = (RGBcol And &H100FF00) / &H100 ' set green
B = (RGBcol And &HFF0000) / &H10000 ' set blue

End Sub


Sub InitBrush(r0, g0, b0, r1, g1, b1, MinValue, MaxValue, Optional NN = 255)
Dim I
Dim R
Dim G
Dim B
Dim i2
'ReDim BRUSH(NN)

'Range = (MaxValue - MinValue)
'
'For I = MinValue To MaxValue Step Range / NN
'
'    i2 = Round(((I - MinValue) / Range) * NN)
'
'    R = r0 + (I - MinValue) + (r1 - r0) * (I - MinValue) / Range
'    G = g0 + (I - MinValue) + (g1 - g0) * (I - MinValue) / Range
'    B = b0 + (I - MinValue) + (b1 - b0) * (I - MinValue) / Range
'
'    BRUSH(i2) = CreateSolidBrush(RGB(R, G, B))
'
'Next

ReDim BRUSH(MinValue To MaxValue)
For I = MinValue To MaxValue
    
    
    'R = (I * 0.7 + 127)
    'G = (I * 0.9 + 127)
    'B = (I + 127)
    R = r0 + (r1 - r0) * (I - MinValue + 1) / 255
    G = g0 + (g1 - g0) * (I - MinValue + 1) / 255
    B = b0 + (b1 - b0) * (I - MinValue + 1) / 255
    
    
    BRUSH(I) = CreateSolidBrush(RGB(R, G, B))
Next

End Sub




Public Sub MySetPixel(hdc, ByVal x, ByVal y, VV)


Rect.X1 = (x) * DIV
Rect.Y1 = (y) * DIV
Rect.X2 = Rect.X1 + DIV '- 1
Rect.Y2 = Rect.Y1 + DIV '- 1

'''VV = Round((VV + 1) / 4 * 255)
''VV = Round((VV - minWH) / (maxWH - minWH) * 255)
'VV = Round((VV - minWH) * Krange)

FillRect hdc, Rect, BRUSH(VV)


End Sub


