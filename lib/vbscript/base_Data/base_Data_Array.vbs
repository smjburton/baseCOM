Option Explicit

Include "base_Data_Array_Util"

Class base_Data_Array
	Private p_Array

	Private Sub Class_Initialize()

	End Sub


	' Properties:


	Public Property Get Allocated()
		If IsArrayAllocated(p_Array) Then
			Allocated = True
		Else
			Allocated = False
		End If
	End Property

	Public Default Property Get Item(intIndex)
		If IsArrayAllocated(p_Array) Then
    			If IsObject(p_Array(intIndex)) Then
        			Set Item = p_Array(intIndex)
    			Else
        			Item = p_Array(intIndex)
    			End If
		End If
	End Property

	Public Property Let Item(intIndex, varInput)
		If IsArrayAllocated(p_Array) Then p_Array(intIndex) = varInput
	End Property

	Public Property Set Item(intIndex, objInput)
		If IsArrayAllocated(p_Array) Then Set p_Array(intIndex) = varInput
	End Property

	Public Property Get Length()
		If IsArrayAllocated(p_Array) Then Length = UBound(p_Array) + 1
	End Property


	' Methods:


	Public Sub Append(varInput)
		If IsArray(varInput) Then
			Dim i

			Extend UBound(varInput) + 1, True

			For i = 0 To UBound(varInput)
				If IsObject(varInput(i)) Then
					Set p_Array(UBound(p_Array) - UBound(varInput) + i) = varInput(i)
				Else
					p_Array(UBound(p_Array) - UBound(varInput) + i) = varInput(i)
				End If
			Next
		Else
			Extend 1, True

			If IsObject(varInput) Then
				Set p_Array(UBound(p_Array)) = varInput
			Else
				p_Array(UBound(p_Array)) = varInput
			End If
		End If
	End Sub

	Public Sub Insert(varInput, intIndex)
		Dim objArray
		Set objArray = Slice(LBound(p_Array), intIndex - 1)
		objArray.Append varInput
		If UBound(p_Array) > intIndex Then objArray.Append Slice(intIndex, UBound(p_Array)).ToArray()
		Me.FromArray objArray.ToArray()
		Set objArray = Nothing
	End Sub

	Public Sub RemoveAt(intIndex)
		If IsArrayAllocated(p_Array) Then
			Dim objArray, _
				i

			Set objArray = New base_Data_Array

			For i = 0 To UBound(p_Array)
  				Do
    					If i = intIndex Then Exit Do
        				
					objArray.Append p_Array(i)
  				Loop While False
			Next

			Me.FromArray objArray.ToArray()
			Set objArray = Nothing
		End If
	End Sub

	Public Sub RemoveValue(varInput)
		RemoveAt IndexOf(varInput)
	End Sub

	Public Sub Push(varInput)
		Append(varInput)
	End Sub

	Public Function Pop(intIndex)
		Pop = Item(intIndex)
		RemoveAt intIndex
	End Function
	
	Public Function Slice(intStart, intEnd)
		Dim objArr, _
			i

		Set objArr = New base_Data_Array

		For i = intStart To intEnd
			objArr.Append Me(i)
		Next

		Set Slice = objArr
	End Function

	Public Sub Splice(intIndex, intRemove, arrInput)
		Dim objArray
		Set objArray = Slice(LBound(p_Array), intIndex - 1)
		objArray.Append arrInput
		If UBound(p_Array) > (intIndex + intRemove) Then objArray.Append Slice(intIndex + intRemove, UBound(p_Array)).ToArray()
		Me.FromArray objArray.ToArray()
		Set objArray = Nothing
	End Sub

	Public Sub Extend(intSize, blnPreserve)
		If IsArrayAllocated(p_Array) Then
			If blnPreserve Then
				ReDim Preserve p_Array(UBound(p_Array) + intSize)
			Else
				ReDim p_Array(UBound(p_Array) + intSize)
			End If
		Else
			p_Array = Array()
			ReDim p_Array(intSize - 1)
		End If
	End Sub

	Public Sub Resize(intSize, blnPreserve)
		If IsArrayAllocated(p_Array) Then
			If blnPreserve Then
				ReDim Preserve p_Array(intSize - 1)
			Else
				ReDim p_Array(intSize - 1)
			End If
		Else
			p_Array = Array()
			ReDim p_Array(intSize - 1)
		End If
	End Sub

	Public Function IndexOf(varInput)
		Dim intIndex, _
			i

		For i = 0 To UBound(p_Array)
			If IsObject(varInput) And IsObject(p_Array(i)) Then
				If p_Array(i) Is varInput Then intIndex = i
			ElseIf Not IsObject(p_Array(i)) And Not IsObject(varInput) Then
				If p_Array(i) = varInput Then intIndex = i
			End If
			If Not IsEmpty(intIndex) Then Exit For
		Next

		If Not IsEmpty(intIndex) Then IndexOf = intIndex
	End Function

	Public Sub Sort()
		QuickSort p_Array, LBound(p_Array), UBound(p_Array)
	End Sub

	Public Sub Reverse()
		If IsArrayAllocated(p_Array) Then
			Dim objArray, _
				i

			Set objArray = New base_Data_Array

			For i = UBound(p_Array) To 0 Step -1
				objArray.Append p_Array(i)
			Next

			Me.FromArray objArray.ToArray()
			Set objArray = Nothing
		End If
	End Sub

	Public Sub FromArray(arrInput)
		If IsArray(arrInput) Then
			If IsArrayAllocated(p_Array) Then Clear
			p_Array = arrInput
		End If
	End Sub

	Public Function ToArray()
		If IsArrayAllocated(p_Array) Then ToArray = p_Array
	End Function

	Public Sub FromString(strInput, varDelimiter)
		If TypeName(strInput) = "String" Then
			If IsArrayAllocated(p_Array) Then Clear
			p_Array = Split(strInput, CStr(varDelimiter))
		End If
	End Sub

	Public Function ToString()
		If IsArrayAllocated(p_Array) Then ToString = Join(p_Array, ", ")
	End Function

	Public Function Clone()
		Dim objArray
		Set objArray = New base_Data_Array
		objArray.FromArray Me.ToArray()
		Set Clone = objArray
	End Function

	Public Sub Clear()
		If IsArrayAllocated(p_Array) Then Erase p_Array
	End Sub

	Private Sub Class_Terminate()
		Clear()
	End Sub
End Class

If WScript.ScriptName = "base_Data_Array.vbs" Then
	Dim objArray, _
		i

	Set objArray = New base_Data_Array

	' objArray.FromArray Array("Banana", "Orange", "Lemon", "Apple", "Mango")
	' objArray.Append Array("Car", "Bus", "Train", "Boat")
	' objArray.Splice 2, 0, Array("Lime", "Kiwi")

	objArray.FromString "Banana, Apple, Mango, Kiwi", ","

	WScript.Echo objArray(0)

	' For i = 0 To objArray.Length - 1
	' 	WScript.Echo "objArray(" & i & ") = " & objArray(i)
	' Next
End If
