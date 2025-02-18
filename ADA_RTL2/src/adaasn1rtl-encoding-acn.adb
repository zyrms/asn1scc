with Ada.Unchecked_Conversion;

package body adaasn1rtl.encoding.acn with
   Spark_Mode
is

   procedure Acn_Enc_Int_PositiveInteger_ConstSize
     (bs : in out Bitstream; IntVal : Asn1UInt; sizeInBits : Integer)
   is
   begin
      BitStream_Encode_Non_Negative_Integer (bs, IntVal, sizeInBits);
   end Acn_Enc_Int_PositiveInteger_ConstSize;

   procedure Acn_Enc_Int_PositiveInteger_ConstSize_8
     (bs : in out Bitstream; IntVal : Asn1UInt)
   is
   begin
      BitStream_AppendByte (bs, Asn1Byte (IntVal), False);
   end Acn_Enc_Int_PositiveInteger_ConstSize_8;

   procedure Acn_Enc_Int_PositiveInteger_ConstSize_big_endian_16
     (bs : in out Bitstream; IntVal : Asn1UInt)
   is
   begin
      Enc_UInt (bs, IntVal, 2);
   end Acn_Enc_Int_PositiveInteger_ConstSize_big_endian_16;

   procedure Acn_Enc_Int_PositiveInteger_ConstSize_big_endian_32
     (bs : in out Bitstream; IntVal : Asn1UInt)
   is
   begin
      Enc_UInt (bs, IntVal, 4);
   end Acn_Enc_Int_PositiveInteger_ConstSize_big_endian_32;

   procedure Acn_Enc_Int_PositiveInteger_ConstSize_big_endian_64
     (bs : in out Bitstream; IntVal : Asn1UInt)
   is
   begin
      pragma Warnings (Off, "loop range is null, loop will not execute");
      pragma Warnings (Off, "this statement is never reached");
      pragma Warnings (Off, "statement has no effect");

      for i in 1 .. 8 - Asn1UInt'Size / 8 loop
         BitStream_AppendByte (bs, 0, False);
      end loop;
      pragma Warnings (On, "loop range is null, loop will not execute");
      pragma Warnings (On, "this statement is never reached");
      pragma Warnings (On, "statement has no effect");

      Enc_UInt (bs, IntVal, Asn1UInt'Size / 8);
   end Acn_Enc_Int_PositiveInteger_ConstSize_big_endian_64;

   procedure Acn_Enc_Int_PositiveInteger_ConstSize_little_endian_N
     (bs : in out Bitstream; IntVal : Asn1UInt; total_bytes : Integer) with
      Depends => (bs => (bs, IntVal, total_bytes)),
      Pre     => total_bytes >= 0 and then total_bytes <= Asn1UInt'Size / 8
      and then bs.Current_Bit_Pos < Natural'Last - total_bytes * 8
      and then bs.Size_In_Bytes < Positive'Last / 8
      and then bs.Current_Bit_Pos <= bs.Size_In_Bytes * 8 - total_bytes * 8,
      Post => bs.Current_Bit_Pos = bs'Old.Current_Bit_Pos + total_bytes * 8;

   procedure Acn_Enc_Int_PositiveInteger_ConstSize_little_endian_N
     (bs : in out Bitstream; IntVal : Asn1UInt; total_bytes : Integer)
   is
      byteValue : Asn1Byte;
      tmp       : Asn1UInt := IntVal;
   begin
      for i in 1 .. total_bytes loop
         byteValue := Asn1Byte (tmp mod 256);
         pragma Loop_Invariant
           (bs.Current_Bit_Pos = bs.Current_Bit_Pos'Loop_Entry + (i - 1) * 8);
         BitStream_AppendByte (bs, byteValue, False);
         tmp := tmp / 256;
      end loop;
   end Acn_Enc_Int_PositiveInteger_ConstSize_little_endian_N;

   procedure Acn_Enc_Int_PositiveInteger_ConstSize_little_endian_16
     (bs : in out Bitstream; IntVal : Asn1UInt)
   is
   begin
      Acn_Enc_Int_PositiveInteger_ConstSize_little_endian_N (bs, IntVal, 2);
   end Acn_Enc_Int_PositiveInteger_ConstSize_little_endian_16;

   procedure Acn_Enc_Int_PositiveInteger_ConstSize_little_endian_32
     (bs : in out Bitstream; IntVal : Asn1UInt)
   is
   begin
      Acn_Enc_Int_PositiveInteger_ConstSize_little_endian_N (bs, IntVal, 4);
   end Acn_Enc_Int_PositiveInteger_ConstSize_little_endian_32;

   procedure Acn_Enc_Int_PositiveInteger_ConstSize_little_endian_64
     (bs : in out Bitstream; IntVal : Asn1UInt)
   is
   begin
      Acn_Enc_Int_PositiveInteger_ConstSize_little_endian_N
        (bs, IntVal, Asn1UInt'Size / 8);
      pragma Warnings (Off, "loop range is null, loop will not execute");
      pragma Warnings (Off, "this statement is never reached");
      pragma Warnings (Off, "statement has no effect");
      for i in 1 .. 8 - Asn1UInt'Size / 8 loop
         BitStream_AppendByte (bs, 0, False);
      end loop;
      pragma Warnings (On, "loop range is null, loop will not execute");
      pragma Warnings (On, "this statement is never reached");
      pragma Warnings (On, "statement has no effect");

   end Acn_Enc_Int_PositiveInteger_ConstSize_little_endian_64;

   procedure Acn_Enc_Int_PositiveInteger_VarSize_LengthEmbedded
     (bs : in out Bitstream; IntVal : Asn1UInt)
   is
   begin
      Enc_SemiConstraintPosWholeNumber (bs, IntVal, 0);
   end Acn_Enc_Int_PositiveInteger_VarSize_LengthEmbedded;

   procedure Acn_Enc_Int_TwosComplement_ConstSize
     (bs : in out Bitstream; IntVal : Asn1Int; sizeInBits : Natural)
   is
   begin
      BitStream_Encode_Non_Negative_Integer (bs, To_UInt (IntVal), sizeInBits);
   end Acn_Enc_Int_TwosComplement_ConstSize;

   procedure Acn_Enc_Int_TwosComplement_ConstSize_8
     (bs : in out Bitstream; IntVal : Asn1Int)
   is
   begin
      BitStream_AppendByte (bs, Asn1Byte (To_UInt (IntVal) and 16#FF#), False);
   end Acn_Enc_Int_TwosComplement_ConstSize_8;

   procedure Acn_Enc_Int_TwosComplement_ConstSize_big_endian_16
     (bs : in out Bitstream; IntVal : Asn1Int)
   is
   begin
      Enc_UInt (bs, To_UInt (IntVal), 2);
   end Acn_Enc_Int_TwosComplement_ConstSize_big_endian_16;

   procedure Acn_Enc_Int_TwosComplement_ConstSize_big_endian_32
     (bs : in out Bitstream; IntVal : Asn1Int)
   is
   begin
      Enc_UInt (bs, To_UInt (IntVal), 4);
   end Acn_Enc_Int_TwosComplement_ConstSize_big_endian_32;

   procedure Acn_Enc_Int_TwosComplement_ConstSize_big_endian_64
     (bs : in out Bitstream; IntVal : Asn1Int)
   is
   begin
      pragma Warnings (Off, "loop range is null, loop will not execute");
      pragma Warnings (Off, "this statement is never reached");
      pragma Warnings (Off, "statement has no effect");
      for i in 1 .. 8 - Asn1UInt'Size / 8 loop
         BitStream_AppendByte (bs, (if IntVal >= 0 then 0 else 255), False);
      end loop;
      pragma Warnings (On, "loop range is null, loop will not execute");
      pragma Warnings (On, "this statement is never reached");
      pragma Warnings (On, "statement has no effect");
      Enc_UInt (bs, To_UInt (IntVal), Asn1UInt'Size / 8);
   end Acn_Enc_Int_TwosComplement_ConstSize_big_endian_64;

   procedure Acn_Enc_Int_TwosComplement_ConstSize_little_endian_16
     (bs : in out Bitstream; IntVal : Asn1Int)
   is
   begin
      Acn_Enc_Int_PositiveInteger_ConstSize_little_endian_N
        (bs, To_UInt (IntVal), 2);
   end Acn_Enc_Int_TwosComplement_ConstSize_little_endian_16;

   procedure Acn_Enc_Int_TwosComplement_ConstSize_little_endian_32
     (bs : in out Bitstream; IntVal : Asn1Int)
   is
   begin
      Acn_Enc_Int_PositiveInteger_ConstSize_little_endian_N
        (bs, To_UInt (IntVal), 4);
   end Acn_Enc_Int_TwosComplement_ConstSize_little_endian_32;

   procedure Acn_Enc_Int_TwosComplement_ConstSize_little_endian_64
     (bs : in out Bitstream; IntVal : Asn1Int)
   is
   begin
      Acn_Enc_Int_PositiveInteger_ConstSize_little_endian_N
        (bs, To_UInt (IntVal), Asn1UInt'Size / 8);

      pragma Warnings (Off, "loop range is null, loop will not execute");
      pragma Warnings (Off, "this statement is never reached");
      pragma Warnings (Off, "statement has no effect");

      for i in 1 .. 8 - Asn1UInt'Size / 8 loop
         BitStream_AppendByte (bs, (if IntVal >= 0 then 0 else 255), False);
      end loop;

      pragma Warnings (On, "loop range is null, loop will not execute");
      pragma Warnings (On, "this statement is never reached");
      pragma Warnings (On, "statement has no effect");

   end Acn_Enc_Int_TwosComplement_ConstSize_little_endian_64;

   procedure Acn_Enc_Int_TwosComplement_VarSize_LengthEmbedded
     (bs : in out Bitstream; IntVal : Asn1Int)
   is
   begin
      Enc_UnConstraintWholeNumber (bs, IntVal);
   end Acn_Enc_Int_TwosComplement_VarSize_LengthEmbedded;

--   subtype OctetArray100 is OctetBuffer (1..100);

   procedure Acn_Enc_Int_BCD_ConstSize
     (bs : in out Bitstream; IntVal : Asn1UInt; nNibbles : Integer)
   is
      intValCopy : Asn1UInt := IntVal;
      powOf10    : Asn1UInt;
      curNibble  : Asn1Byte;
   begin
      for i in 1 .. nNibbles loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos = bs.Current_Bit_Pos'Loop_Entry + (i - 1) * 4);
         powOf10    := Powers_of_10 (nNibbles - i);
         curNibble  := Asn1Byte (intValCopy / powOf10 and 16#FF#);
         intValCopy := intValCopy mod powOf10;
         BitStream_AppendPartialByte (bs, curNibble, 4, False);
      end loop;
   end Acn_Enc_Int_BCD_ConstSize;

   procedure Acn_Enc_Int_BCD_VarSize_NullTerminated
     (bs : in out Bitstream; IntVal : Asn1UInt)
   is
      totalNibbles : Integer;
   begin
      totalNibbles := Get_number_of_digits (IntVal);
      Acn_Enc_Int_BCD_ConstSize (bs, IntVal, totalNibbles);
      BitStream_AppendPartialByte (bs, 16#F#, 4, False);
   end Acn_Enc_Int_BCD_VarSize_NullTerminated;

   procedure Get_integer_digits
     (IntVal      :     Asn1UInt; digits_array : out Digits_Buffer;
      totalDigits : out Asn1Byte) with
      Post => totalDigits >= 1 and totalDigits <= 20 and
      totalDigits = Asn1Byte (Get_number_of_digits (IntVal));

   procedure Get_integer_digits
     (IntVal      :     Asn1UInt; digits_array : out Digits_Buffer;
      totalDigits : out Asn1Byte)
   is
      intValCopy : Asn1UInt := IntVal;
      powOf10    : Asn1UInt;
      curNibble  : Asn1Byte;
   begin
      digits_array := (others => 0);
      totalDigits  := Asn1Byte (Get_number_of_digits (IntVal));
      for i in 1 .. Integer (totalDigits) loop
         powOf10          := Powers_of_10 (Integer (totalDigits) - i);
         curNibble        := Asn1Byte (intValCopy / powOf10 and 16#F#);
         intValCopy       := intValCopy mod powOf10;
         digits_array (i) := Asn1Byte (Character'Pos ('0') + curNibble);
      end loop;
   end Get_integer_digits;

   procedure Acn_Enc_Int_ASCII_VarSize_LengthEmbedded
     (bs : in out Bitstream; IntVal : Asn1Int)
   is
      digits_array : Digits_Buffer;
      nChars       : Asn1Byte;
      sing         : Asn1Byte;
      absIntVal    : Asn1UInt;

   begin

      absIntVal := Asn1UInt (abs IntVal);
      sing      :=
        (if IntVal >= 0 then Character'Pos ('+') else Character'Pos ('-'));
      Get_integer_digits (absIntVal, digits_array, nChars);
      pragma Assert (nChars <= 18);

      --  encode length, plus 1 for sign
      BitStream_AppendByte (bs, nChars + 1, False);

      --  encode sign
      BitStream_AppendByte (bs, sing, False);

      for i in 1 .. Integer (nChars) loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos = bs.Current_Bit_Pos'Loop_Entry + (i - 1) * 8);
         BitStream_AppendByte (bs, digits_array (i), False);
      end loop;

   end Acn_Enc_Int_ASCII_VarSize_LengthEmbedded;

   procedure Acn_Enc_UInt_ASCII_VarSize_LengthEmbedded
     (bs : in out Bitstream; IntVal : Asn1UInt)
   is
      digits_array : Digits_Buffer;
      nChars       : Asn1Byte;
   begin
      Get_integer_digits (IntVal, digits_array, nChars);

      --  encode length
      BitStream_AppendByte (bs, nChars, False);

      for i in 1 .. Integer (nChars) loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos = bs.Current_Bit_Pos'Loop_Entry + (i - 1) * 8);
         BitStream_AppendByte (bs, digits_array (i), False);
      end loop;

   end Acn_Enc_UInt_ASCII_VarSize_LengthEmbedded;

   procedure Acn_Enc_Int_ASCII_VarSize_NullTerminated
     (bs : in out Bitstream; IntVal : Asn1Int; nullChars : OctetBuffer)
   is
      digits_array : Digits_Buffer;
      nChars       : Asn1Byte;
      sing         : Asn1Byte;
      absIntVal    : Asn1UInt;
   begin
      absIntVal :=
        (if IntVal >= 0 then Asn1UInt (IntVal)
         else (Asn1UInt (-(IntVal + 1)) + 1));
      sing :=
        (if IntVal >= 0 then Character'Pos ('+') else Character'Pos ('-'));
      Get_integer_digits (absIntVal, digits_array, nChars);

      --  encode sign
      BitStream_AppendByte (bs, sing, False);

      --  encode digits
      for i in 1 .. Integer (nChars) loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos = bs.Current_Bit_Pos'Loop_Entry + (i - 1) * 8);
         BitStream_AppendByte (bs, digits_array (i), False);
      end loop;

      --  encode nullChar
      for i in nullChars'Range loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos =
            bs.Current_Bit_Pos'Loop_Entry + (i - nullChars'First) * 8);
         BitStream_AppendByte (bs, nullChars (i), False);
      end loop;

   end Acn_Enc_Int_ASCII_VarSize_NullTerminated;

   procedure Acn_Enc_UInt_ASCII_VarSize_NullTerminated
     (bs : in out Bitstream; IntVal : Asn1UInt; nullChars : OctetBuffer)
   is
      digits_array : Digits_Buffer;
      nChars       : Asn1Byte;
   begin
      Get_integer_digits (IntVal, digits_array, nChars);

      --   encode digits
      for i in 1 .. Integer (nChars) loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos = bs.Current_Bit_Pos'Loop_Entry + (i - 1) * 8);
         BitStream_AppendByte (bs, digits_array (i), False);
      end loop;

      --   encode nullChar
      for i in nullChars'Range loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos =
            bs.Current_Bit_Pos'Loop_Entry + (i - nullChars'First) * 8);
         BitStream_AppendByte (bs, nullChars (i), False);
      end loop;

   end Acn_Enc_UInt_ASCII_VarSize_NullTerminated;

   --  -------------------- Decoding functions --------------------------------

   procedure Acn_Dec_Int_PositiveInteger_ConstSize
     (bs     : in out Bitstream; IntVal : out Asn1UInt; minVal : Asn1UInt;
      maxVal :    Asn1UInt; nSizeInBits : Integer; Result : out ASN1_RESULT)
   is
      encVal : Asn1UInt;
   begin
      Result.ErrorCode := 0;
      BitStream_Decode_Non_Negative_Integer
        (bs, encVal, nSizeInBits, Result.Success);
      pragma Assert (Result.Success);
      IntVal := encVal;

      Result.Success := IntVal >= minVal and IntVal <= maxVal;
      if not Result.Success then
         IntVal           := minVal;
         Result.ErrorCode := ERR_INCORRECT_STREAM;
      end if;
   end Acn_Dec_Int_PositiveInteger_ConstSize;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_8
     (bs     : in out Bitstream; IntVal : out Asn1UInt; minVal : Asn1UInt;
      maxVal :        Asn1UInt; Result : out ASN1_RESULT)
   is
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize
        (bs, IntVal, minVal, maxVal, 8, Result);
   end Acn_Dec_Int_PositiveInteger_ConstSize_8;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_16
     (bs     : in out Bitstream; IntVal : out Asn1UInt; minVal : Asn1UInt;
      maxVal :        Asn1UInt; Result : out ASN1_RESULT)
   is
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize
        (bs, IntVal, minVal, maxVal, 16, Result);
   end Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_16;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_32
     (bs     : in out Bitstream; IntVal : out Asn1UInt; minVal : Asn1UInt;
      maxVal :        Asn1UInt; Result : out ASN1_RESULT)
   is
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize
        (bs, IntVal, minVal, maxVal, 32, Result);
   end Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_32;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_64
     (bs     : in out Bitstream; IntVal : out Asn1UInt; minVal : Asn1UInt;
      maxVal :        Asn1UInt; Result : out ASN1_RESULT)
   is
   begin
      Result.ErrorCode   := 0;
      bs.Current_Bit_Pos := bs.Current_Bit_Pos + (64 - Asn1UInt'Size);
      Dec_UInt (bs, Asn1UInt'Size / 8, IntVal, Result.Success);
      Result.Success :=
        Result.Success and then IntVal >= minVal and then IntVal <= maxVal;
      if not Result.Success then
         IntVal           := minVal;
         Result.ErrorCode := ERR_INCORRECT_STREAM;
      end if;
   end Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_64;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_N0
     (bs : in out Bitstream; IntVal : out Asn1UInt; total_bytes : Integer) with
      Pre => total_bytes >= 0 and then total_bytes <= Asn1UInt'Size / 8
      and then bs.Current_Bit_Pos < Natural'Last - total_bytes * 8
      and then bs.Size_In_Bytes < Positive'Last / 8
      and then bs.Current_Bit_Pos <= bs.Size_In_Bytes * 8 - total_bytes * 8,
      Post => bs.Current_Bit_Pos = bs'Old.Current_Bit_Pos + total_bytes * 8;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_N0
     (bs : in out Bitstream; IntVal : out Asn1UInt; total_bytes : Integer)
   is
      byteValue : Asn1Byte;
      result    : Asn1Boolean;
      tmp       : Asn1UInt;
   begin
      IntVal := 0;
      for i in 1 .. total_bytes loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos = bs.Current_Bit_Pos'Loop_Entry + (i - 1) * 8);
         BitStream_DecodeByte (bs, byteValue, result);
         pragma Assert (result);
         tmp    := Shift_Left (Asn1UInt (byteValue), (i - 1) * 8);
         IntVal := IntVal or tmp;
      end loop;
   end Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_N0;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_N
     (bs     : in out Bitstream; IntVal : out Asn1UInt; minVal : Asn1UInt;
      maxVal : Asn1UInt; Result : out ASN1_RESULT; total_bytes : Integer) with
      Pre => total_bytes >= 0 and then total_bytes <= Asn1UInt'Size / 8
      and then bs.Current_Bit_Pos < Natural'Last - total_bytes * 8
      and then bs.Size_In_Bytes < Positive'Last / 8
      and then bs.Current_Bit_Pos <= bs.Size_In_Bytes * 8 - total_bytes * 8,
      Post => bs.Current_Bit_Pos = bs'Old.Current_Bit_Pos + total_bytes * 8 and
      ((Result.Success and IntVal >= minVal and IntVal <= maxVal) or
       (not Result.Success and IntVal = minVal));

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_N
     (bs     : in out Bitstream; IntVal : out Asn1UInt; minVal : Asn1UInt;
      maxVal :    Asn1UInt; Result : out ASN1_RESULT; total_bytes : Integer)
   is
   begin
      Result.ErrorCode := 0;
      Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_N0
        (bs, IntVal, total_bytes);
      Result.Success := IntVal >= minVal and IntVal <= maxVal;
      if not Result.Success then
         IntVal           := minVal;
         Result.ErrorCode := ERR_INCORRECT_STREAM;
      end if;
   end Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_N;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_16
     (bs     : in out Bitstream; IntVal : out Asn1UInt; minVal : Asn1UInt;
      maxVal :        Asn1UInt; Result : out ASN1_RESULT)
   is
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_N
        (bs, IntVal, minVal, maxVal, Result, 2);
   end Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_16;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_32
     (bs     : in out Bitstream; IntVal : out Asn1UInt; minVal : Asn1UInt;
      maxVal :        Asn1UInt; Result : out ASN1_RESULT)
   is
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_N
        (bs, IntVal, minVal, maxVal, Result, 4);
   end Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_32;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_64
     (bs     : in out Bitstream; IntVal : out Asn1UInt; minVal : Asn1UInt;
      maxVal :        Asn1UInt; Result : out ASN1_RESULT)
   is
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_N
        (bs, IntVal, minVal, maxVal, Result, Asn1UInt'Size / 8);
      bs.Current_Bit_Pos := bs.Current_Bit_Pos + (64 - Asn1UInt'Size);
   end Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_64;

   procedure Acn_Dec_Int_PositiveInteger_VarSize_LengthEmbedded
     (bs     : in out Bitstream; IntVal : out Asn1UInt; minVal : Asn1UInt;
      Result :    out ASN1_RESULT)
   is
      NBytes : Asn1Byte;
      Ret    : Asn1UInt;
   begin

      IntVal           := minVal;
      Result.ErrorCode := 0;
      BitStream_DecodeByte (bs, NBytes, Result.Success);

      if Result.Success and NBytes >= 1 and NBytes <= Asn1UInt'Size / 8 then
         Dec_UInt (bs, Integer (NBytes), Ret, Result.Success);
         pragma Assert (Result.Success);
         IntVal         := Ret;
         Result.Success := IntVal >= minVal;
         if not Result.Success then
            IntVal           := minVal;
            Result.ErrorCode := ERR_INCORRECT_STREAM;
         end if;
      else
         Result.ErrorCode := ERR_INCORRECT_STREAM;
         Result.Success   := False;
      end if;
   end Acn_Dec_Int_PositiveInteger_VarSize_LengthEmbedded;

   procedure Acn_Dec_Int_TwosComplement_ConstSize
     (bs     : in out Bitstream; IntVal : out Asn1Int; minVal : Asn1Int;
      maxVal :        Asn1Int; nSizeInBits : Integer; Result : out ASN1_RESULT)
   is
      encVal : Asn1UInt;
   begin
      Result.ErrorCode := 0;
      BitStream_Decode_Non_Negative_Integer
        (bs, encVal, nSizeInBits, Result.Success);
      if Result.Success then
         IntVal :=
           (if nSizeInBits = 0 then 0 else To_Int_n (encVal, nSizeInBits));
         Result.Success := IntVal >= minVal and IntVal <= maxVal;
         if not Result.Success then
            IntVal           := minVal;
            Result.ErrorCode := ERR_INCORRECT_STREAM;
         end if;
      else
         IntVal           := minVal;
         Result.ErrorCode := ERR_INCORRECT_STREAM;
      end if;
   end Acn_Dec_Int_TwosComplement_ConstSize;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_8
     (bs     : in out Bitstream; IntVal : out Asn1Int; minVal : Asn1Int;
      maxVal :        Asn1Int; Result : out ASN1_RESULT)
   is
   begin
      Acn_Dec_Int_TwosComplement_ConstSize
        (bs, IntVal, minVal, maxVal, 8, Result);
   end Acn_Dec_Int_TwosComplement_ConstSize_8;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_big_endian_16
     (bs     : in out Bitstream; IntVal : out Asn1Int; minVal : Asn1Int;
      maxVal :        Asn1Int; Result : out ASN1_RESULT)
   is
   begin
      Acn_Dec_Int_TwosComplement_ConstSize
        (bs, IntVal, minVal, maxVal, 16, Result);
   end Acn_Dec_Int_TwosComplement_ConstSize_big_endian_16;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_big_endian_32
     (bs     : in out Bitstream; IntVal : out Asn1Int; minVal : Asn1Int;
      maxVal :        Asn1Int; Result : out ASN1_RESULT)
   is
   begin
      Acn_Dec_Int_TwosComplement_ConstSize
        (bs, IntVal, minVal, maxVal, 32, Result);
   end Acn_Dec_Int_TwosComplement_ConstSize_big_endian_32;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_big_endian_64
     (bs     : in out Bitstream; IntVal : out Asn1Int; minVal : Asn1Int;
      maxVal :        Asn1Int; Result : out ASN1_RESULT)
   is
      encVal : Asn1UInt;
   begin
      Result.ErrorCode   := 0;
      bs.Current_Bit_Pos := bs.Current_Bit_Pos + (64 - Asn1UInt'Size);
      Dec_UInt (bs, Asn1UInt'Size / 8, encVal, Result.Success);
      pragma Assert (Result.Success);
      IntVal         := To_Int (encVal);
      Result.Success := IntVal >= minVal and IntVal <= maxVal;
      if not Result.Success then
         IntVal           := minVal;
         Result.ErrorCode := ERR_INCORRECT_STREAM;
      end if;
   end Acn_Dec_Int_TwosComplement_ConstSize_big_endian_64;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_little_endian_N
     (bs     : in out Bitstream; IntVal : out Asn1Int; minVal : Asn1Int;
      maxVal : Asn1Int; Result : out ASN1_RESULT; total_bytes : Integer) with
      Pre => total_bytes > 0 and then total_bytes <= Asn1Int'Size / 8
      and then bs.Current_Bit_Pos < Natural'Last - total_bytes * 8
      and then bs.Size_In_Bytes < Positive'Last / 8
      and then bs.Current_Bit_Pos <= bs.Size_In_Bytes * 8 - total_bytes * 8,
      Post => bs.Current_Bit_Pos = bs'Old.Current_Bit_Pos + total_bytes * 8 and
      ((Result.Success and IntVal >= minVal and IntVal <= maxVal) or
       (not Result.Success and IntVal = minVal));

   procedure Acn_Dec_Int_TwosComplement_ConstSize_little_endian_N
     (bs     : in out Bitstream; IntVal : out Asn1Int; minVal : Asn1Int;
      maxVal :        Asn1Int; Result : out ASN1_RESULT; total_bytes : Integer)
   is
      encValue : Asn1UInt;

   begin
      Result.ErrorCode := 0;
      Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_N0
        (bs, encValue, total_bytes);
      IntVal :=
        (if total_bytes = 8 then To_Int (encValue)
         else To_Int_n (encValue, total_bytes * 8));
      Result.Success := IntVal >= minVal and IntVal <= maxVal;
      if not Result.Success then
         IntVal           := minVal;
         Result.ErrorCode := ERR_INCORRECT_STREAM;
      end if;
   end Acn_Dec_Int_TwosComplement_ConstSize_little_endian_N;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_little_endian_16
     (bs     : in out Bitstream; IntVal : out Asn1Int; minVal : Asn1Int;
      maxVal :        Asn1Int; Result : out ASN1_RESULT)
   is
   begin
      Acn_Dec_Int_TwosComplement_ConstSize_little_endian_N
        (bs, IntVal, minVal, maxVal, Result, 2);
   end Acn_Dec_Int_TwosComplement_ConstSize_little_endian_16;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_little_endian_32
     (bs     : in out Bitstream; IntVal : out Asn1Int; minVal : Asn1Int;
      maxVal :        Asn1Int; Result : out ASN1_RESULT)
   is
   begin
      Acn_Dec_Int_TwosComplement_ConstSize_little_endian_N
        (bs, IntVal, minVal, maxVal, Result, 4);
   end Acn_Dec_Int_TwosComplement_ConstSize_little_endian_32;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_little_endian_64
     (bs     : in out Bitstream; IntVal : out Asn1Int; minVal : Asn1Int;
      maxVal :        Asn1Int; Result : out ASN1_RESULT)
   is
   begin
      Acn_Dec_Int_TwosComplement_ConstSize_little_endian_N
        (bs, IntVal, minVal, maxVal, Result, Asn1UInt'Size / 8);
      bs.Current_Bit_Pos := bs.Current_Bit_Pos + (64 - Asn1UInt'Size);
   end Acn_Dec_Int_TwosComplement_ConstSize_little_endian_64;

   procedure Acn_Dec_Int_TwosComplement_VarSize_LengthEmbedded
     (bs : in out Bitstream; IntVal : out Asn1Int; Result : out ASN1_RESULT)
   is
   begin
      Result.ErrorCode := ERR_INCORRECT_STREAM;
      Dec_UnConstraintWholeNumber (bs, IntVal, Result.Success);
   end Acn_Dec_Int_TwosComplement_VarSize_LengthEmbedded;

   procedure Acn_Dec_Int_BCD_ConstSize
     (bs     : in out Bitstream; IntVal : out Asn1UInt; minVal : Asn1UInt;
      maxVal :        Asn1UInt; nNibbles : Integer; Result : out ASN1_RESULT)
   is
      digit : Asn1Byte;
   begin
      IntVal := 0;
      Result := ASN1_RESULT'(Success => True, ErrorCode => 0);

      for i in 1 .. nNibbles loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos = bs.Current_Bit_Pos'Loop_Entry + (i - 1) * 4);
         BitStream_ReadNibble (bs, digit, Result.Success);
         pragma Assert (Result.Success);
         Result.Success := digit <= 9;
         if Result.Success then
            IntVal := IntVal * 10;
            IntVal := IntVal + Asn1UInt (digit);
         end if;
         exit when not Result.Success;
      end loop;

      Result.Success :=
        Result.Success and then ((IntVal >= minVal) and (IntVal <= maxVal));
      if not Result.Success then
         Result.ErrorCode := ERR_INCORRECT_STREAM;
         IntVal           := minVal;
      end if;
   end Acn_Dec_Int_BCD_ConstSize;

   procedure Acn_Dec_Int_BCD_VarSize_NullTerminated
     (bs     : in out Bitstream; IntVal : out Asn1UInt; minVal : Asn1UInt;
      maxVal :        Asn1UInt; Result : out ASN1_RESULT)
   is
      digit : Asn1Byte;
   begin
      IntVal := 0;
      Result := ASN1_RESULT'(Success => True, ErrorCode => 0);

      for i in 1 .. Max_Int_Digits - 1 loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos = bs.Current_Bit_Pos'Loop_Entry + (i - 1) * 4);
         BitStream_ReadNibble (bs, digit, Result.Success);
         pragma Assert (Result.Success);
         Result.Success := digit <= 9 or digit = 16#F#;
         if Result.Success and digit /= 16#F# then
            IntVal := IntVal * 10;
            IntVal := IntVal + Asn1UInt (digit);
         end if;
         exit when digit = 16#F# or not Result.Success;
      end loop;

      if Result.Success and (not (digit = 16#F#)) then
         BitStream_ReadNibble (bs, digit, Result.Success);
         Result.Success :=
           Result.Success and then digit = 16#F#
           and then ((IntVal >= minVal) and (IntVal <= maxVal));
      else
         Result.Success :=
           Result.Success and then ((IntVal >= minVal) and (IntVal <= maxVal));
      end if;

      if not Result.Success then
         Result.ErrorCode := ERR_INCORRECT_STREAM;
         IntVal           := minVal;
      end if;
   end Acn_Dec_Int_BCD_VarSize_NullTerminated;

   procedure Acn_Enc_Int_ASCII_ConstSize
     (bs : in out Bitstream; IntVal : Asn1Int; nChars : Integer)
   is
      digits_array : Digits_Buffer;
      nDigits      : Asn1Byte;
      sing         : Asn1Byte;
      absIntVal    : Asn1UInt;
   begin

      absIntVal := abs_value (IntVal);
      sing      :=
        (if IntVal >= 0 then Character'Pos ('+') else Character'Pos ('-'));
      Get_integer_digits (absIntVal, digits_array, nDigits);
      pragma Assert (Integer (nDigits) = Get_number_of_digits (absIntVal));
      pragma Assert (Integer (nDigits) <= nChars);
      --  encode sign
      BitStream_AppendByte (bs, sing, False);

      --  encode trailing zeros
      for i in 1 .. (nChars - Integer (nDigits)) - 1 loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos = bs.Current_Bit_Pos'Loop_Entry + (i - 1) * 8);
         BitStream_AppendByte (bs, Character'Pos ('0'), False);
      end loop;

      --  encode digits
      for i in 1 .. Integer (nDigits) loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos = bs.Current_Bit_Pos'Loop_Entry + (i - 1) * 8);
         BitStream_AppendByte (bs, digits_array (i), False);
      end loop;
   end Acn_Enc_Int_ASCII_ConstSize;

   procedure Acn_Dec_Int_ASCII_ConstSize
     (bs     : in out Bitstream; IntVal : out Asn1Int; minVal : Asn1Int;
      maxVal :        Asn1Int; nChars : Integer; Result : out ASN1_RESULT)
   is
      digit    : Asn1Byte;
      intDigit : Integer;
      Ch       : Character;
      negative : Boolean;
      uval     : Asn1UInt;
   begin
      uval := 0;
      BitStream_DecodeByte (bs, digit, Result.Success);

      Result :=
        ASN1_RESULT'
          (Success =>
             Result.Success
             and then
             (digit = Character'Pos ('+') or else digit = Character'Pos ('-')),
           ErrorCode => ERR_INCORRECT_STREAM);
      if Result.Success then

         negative := digit = Character'Pos ('-');
         for i in 1 .. nChars - 1 loop
            pragma Loop_Invariant
              (bs.Current_Bit_Pos =
               bs.Current_Bit_Pos'Loop_Entry + (i - 1) * 8);
            pragma Loop_Invariant (uval < Powers_of_10 (i));

            BitStream_DecodeByte (bs, digit, Result.Success);
            pragma Assert (Result.Success);
            Ch       := Character'Val (digit);
            intDigit := Character'Pos (Ch) - Character'Pos ('0');

            Result.Success := intDigit >= 0 and intDigit <= 9;
            if Result.Success then
               uval := uval * 10;
               uval := uval + Asn1UInt (intDigit);
            end if;
            Result.Success :=
              Result.Success and then
                 (
                    (negative and then uval <= abs_value (Asn1Int'First))
                       or else
                    (not negative and then uval <= Asn1UInt (Asn1Int'Last)));
            exit when not Result.Success;
         end loop;
         if Result.Success then
            IntVal := (
                       if uval = 0 then Asn1Int (0)
                       elsif negative then (-Asn1Int (uval - 1) - 1)
                       else Asn1Int (uval)
                      );

            Result.Success :=
              Result.Success
              and then ((IntVal >= minVal) and (IntVal <= maxVal));
            if not Result.Success then
               Result.ErrorCode := ERR_INCORRECT_STREAM;
               IntVal           := minVal;
            end if;
         else
            Result.ErrorCode := ERR_INCORRECT_STREAM;
            IntVal           := minVal;
         end if;
      else
         Result.ErrorCode := ERR_INCORRECT_STREAM;
         IntVal           := minVal;
      end if;

   end Acn_Dec_Int_ASCII_ConstSize;

   procedure Acn_Enc_UInt_ASCII_ConstSize
     (bs : in out Bitstream; IntVal : Asn1UInt; nChars : Integer)
   is
      digits_array : Digits_Buffer;
      nDigits      : Asn1Byte;
   begin
      Get_integer_digits (IntVal, digits_array, nDigits);
      pragma Assert (IntVal < Powers_of_10 (nChars));
      pragma Assert (Integer (nDigits) = Get_number_of_digits (IntVal));
      pragma Assert (Integer (nDigits) <= nChars);

      --  encode trailing zeros
      for i in 1 .. (nChars - Integer (nDigits)) loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos = bs.Current_Bit_Pos'Loop_Entry + (i - 1) * 8);
         BitStream_AppendByte (bs, Character'Pos ('0'), False);
      end loop;

      --  encode digits
      for i in 1 .. Integer (nDigits) loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos = bs.Current_Bit_Pos'Loop_Entry + (i - 1) * 8);
         BitStream_AppendByte (bs, digits_array (i), False);
      end loop;
   end Acn_Enc_UInt_ASCII_ConstSize;

   procedure Acn_Dec_UInt_ASCII_ConstSize
     (bs     : in out Bitstream; IntVal : out Asn1UInt; minVal : Asn1UInt;
      maxVal :        Asn1UInt; nChars : Integer; Result : out ASN1_RESULT)
   is
      digit    : Asn1Byte;
      intDigit : Integer;
      Ch       : Character;
   begin
      IntVal := 0;
      Result := ASN1_RESULT'(Success => True, ErrorCode => 0);

      for i in 1 .. nChars loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos = bs.Current_Bit_Pos'Loop_Entry + (i - 1) * 8);
         BitStream_DecodeByte (bs, digit, Result.Success);
         pragma Assert (Result.Success);
         Ch       := Character'Val (digit);
         intDigit := Character'Pos (Ch) - Character'Pos ('0');

         Result.Success :=
           intDigit >= 0 and intDigit <= 9; --  and IntVal <Powers_of_10(i-1);
         if Result.Success then
            IntVal := IntVal * 10;
            IntVal := IntVal + Asn1UInt (intDigit);
         end if;
         exit when not Result.Success;
      end loop;

      Result.Success :=
        Result.Success and then ((IntVal >= minVal) and (IntVal <= maxVal));

      if not Result.Success then
         Result.ErrorCode := ERR_INCORRECT_STREAM;
         IntVal           := minVal;
      end if;

   end Acn_Dec_UInt_ASCII_ConstSize;

   procedure Acn_Dec_UInt_ASCII_VarSize_NullTerminated
     (bs : in out Bitstream; IntVal : out Asn1UInt; nullChars : OctetBuffer;
      Result :    out ASN1_RESULT)
   is
      digit    : Asn1Byte;
      intDigit : Integer;
      Ch       : Character;
      tmp      : OctetBuffer :=
        OctetBuffer'
          (1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0,
           9 => 0, 10 => 0);
   begin
      IntVal := 0;
      Result := ASN1_RESULT'(Success => True, ErrorCode => 0);
      --  read null_character_size characters into the tmp buffer
      for i in nullChars'Range loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos =
            bs.Current_Bit_Pos'Loop_Entry + (i - nullChars'First) * 8);
         BitStream_DecodeByte (bs, digit, Result.Success);
         pragma Assert (Result.Success);
         tmp (i + tmp'First - nullChars'First) := digit;
      end loop;

      pragma Assert (tmp'First = 1);
      pragma Assert (tmp'Last = 10);

      for i in 1 .. Max_Int_Digits loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos =
            bs.Current_Bit_Pos'Loop_Entry + (i - 1) * 8 and
            nullChars'First = 1 and tmp'First = 1);
         digit := tmp (tmp'First);

         for j in nullChars'First .. nullChars'Last - 1 loop
            tmp (j + tmp'First - nullChars'First) :=
              tmp (j + 1 + tmp'First - nullChars'First);
         end loop;

         BitStream_DecodeByte
           (bs, tmp (tmp'First + (nullChars'Last - nullChars'First)),
            Result.Success);
         pragma Assert (Result.Success);

         Ch       := Character'Val (digit);
         intDigit := Character'Pos (Ch) - Character'Pos ('0');

         Result.Success :=
           intDigit >= 0 and intDigit <= 9 and IntVal < Powers_of_10 (i - 1);
         if Result.Success then
            IntVal := IntVal * 10;
            IntVal := IntVal + Asn1UInt (intDigit);
         end if;
         exit when not Result.Success;
         exit when nullChars (nullChars'First .. nullChars'Last) =
           tmp (tmp'First .. tmp'First + (nullChars'Last - nullChars'First));
      end loop;

      if not Result.Success then
         Result.ErrorCode := ERR_INCORRECT_STREAM;
      end if;
   end Acn_Dec_UInt_ASCII_VarSize_NullTerminated;

   procedure Acn_Dec_Int_ASCII_VarSize_NullTerminated
     (bs     : in out Bitstream; IntVal : out Asn1Int; nullChars : OctetBuffer;
      Result :    out ASN1_RESULT)
   is
      digitAscii : Asn1Byte;
      Ch         : Character;
      absIntVal  : Asn1UInt;
   begin
      IntVal := 0;
      Result :=
        ASN1_RESULT'(Success => True, ErrorCode => ERR_INCORRECT_STREAM);
      --  decode sign
      BitStream_DecodeByte (bs, digitAscii, Result.Success);

      Ch := Character'Val (digitAscii);

      Result.Success := Result.Success and (Ch = '+' or Ch = '-');
      if Result.Success then
         Acn_Dec_UInt_ASCII_VarSize_NullTerminated
           (bs, absIntVal, nullChars, Result);

         if Result.Success then
            if absIntVal = 0 then
               IntVal := 0;
            elsif Ch = '+' and absIntVal <= Asn1UInt (Asn1Int'Last) then
               IntVal := Asn1Int (absIntVal);
            elsif Ch = '-' and absIntVal <= Asn1UInt (Asn1Int'Last) + 1 then
               IntVal := -Asn1Int (absIntVal - 1) - 1;
            else
               Result :=
                 ASN1_RESULT'
                   (Success => False, ErrorCode => ERR_INCORRECT_STREAM);
            end if;
         end if;
      end if;

   end Acn_Dec_Int_ASCII_VarSize_NullTerminated;

   function Float_to_OctetArray4 (x : Float) return OctetArray4;

   function Float_to_OctetArray4 (x : Float) return OctetArray4 is
      function do_it is new Ada.Unchecked_Conversion (Float, OctetArray4);
   begin
      return do_it (x);
   end Float_to_OctetArray4;

   function OctetArray4_to_Float (x : OctetArray4) return Float;

   function OctetArray4_to_Float (x : OctetArray4) return Float is
      function do_it is new Ada.Unchecked_Conversion (OctetArray4, Float);
   begin
      return do_it (x);
   end OctetArray4_to_Float;

   function Long_Float_to_OctetArray8 (x : Long_Float) return OctetArray8;

   function Long_Float_to_OctetArray8 (x : Long_Float) return OctetArray8 is
      function do_it is new Ada.Unchecked_Conversion (Long_Float, OctetArray8);
   begin
      return do_it (x);
   end Long_Float_to_OctetArray8;

   function OctetArray8_to_Long_Float (x : OctetArray8) return Long_Float;

   function OctetArray8_to_Long_Float (x : OctetArray8) return Long_Float is
      function do_it is new Ada.Unchecked_Conversion (OctetArray8, Long_Float);
   begin
      return do_it (x);
   end OctetArray8_to_Long_Float;

   procedure Acn_Enc_Real_IEEE754_32_big_endian
     (bs : in out Bitstream; RealVal : Asn1Real)
   is
      tmp : OctetArray4;
   begin
      tmp := Float_to_OctetArray4 (Long_Float_to_Float (RealVal));
      if RequiresReverse then
         for i in reverse 1 .. 4 loop
            pragma Loop_Invariant
              (bs.Current_Bit_Pos =
               bs.Current_Bit_Pos'Loop_Entry + (4 - i) * 8);
            BitStream_AppendByte (bs, tmp (i), False);
         end loop;
      else
         for i in 1 .. 4 loop
            pragma Loop_Invariant
              (bs.Current_Bit_Pos =
               bs.Current_Bit_Pos'Loop_Entry + (i - 1) * 8);
            BitStream_AppendByte (bs, tmp (i), False);
         end loop;
      end if;
   end Acn_Enc_Real_IEEE754_32_big_endian;

   procedure Acn_Dec_Real_IEEE754_32_big_endian
     (bs : in out Bitstream; RealVal : out Asn1Real; Result : out ASN1_RESULT)
   is
      tmp : OctetArray4;
   begin
      Result := ASN1_RESULT'(Success => True, ErrorCode => 0);
      if RequiresReverse then
         for i in reverse 1 .. 4 loop
            pragma Loop_Invariant
              (bs.Current_Bit_Pos =
               bs.Current_Bit_Pos'Loop_Entry + (4 - i) * 8);
            BitStream_DecodeByte (bs, tmp (i), Result.Success);
            pragma Assert (Result.Success);
         end loop;
      else
         for i in 1 .. 4 loop
            pragma Loop_Invariant
              (bs.Current_Bit_Pos =
               bs.Current_Bit_Pos'Loop_Entry + (i - 1) * 8);
            BitStream_DecodeByte (bs, tmp (i), Result.Success);
            pragma Assert (Result.Success);
         end loop;
      end if;
      RealVal := Asn1Real (OctetArray4_to_Float (tmp));
   end Acn_Dec_Real_IEEE754_32_big_endian;

   procedure Acn_Dec_Real_IEEE754_32_big_endian_fp32
     (bs : in out Bitstream; RealVal : out Standard.Float;
       Result : out ASN1_RESULT)
   is
      v : Asn1Real;
   begin
      Acn_Dec_Real_IEEE754_32_big_endian (bs, v, Result);

      pragma Warnings
        (Off, "condition can only be False if invalid values present");
      pragma Warnings
        (Off, "condition is always True");

      Result.Success := Result.Success and then
        Asn1Real (Standard.Float'First) <= v and then
        v <= Asn1Real (Standard.Float'Last);

      pragma Warnings
        (On, "condition can only be False if invalid values present");
      pragma Warnings
        (On, "condition is always True");

      if Result.Success then
         RealVal := Standard.Float (v);
      else
         RealVal := 0.0;
      end if;
   end Acn_Dec_Real_IEEE754_32_big_endian_fp32;

   procedure Acn_Enc_Real_IEEE754_64_big_endian
     (bs : in out Bitstream; RealVal : Asn1Real)
   is
      tmp : OctetArray8;
   begin
      tmp := Long_Float_to_OctetArray8 (Long_Float (RealVal));
      if RequiresReverse then
         for I in reverse 1 .. 8 loop
            pragma Loop_Invariant
              (bs.Current_Bit_Pos =
               bs.Current_Bit_Pos'Loop_Entry + (8 - I) * 8);
            BitStream_AppendByte (bs, tmp (I), False);
         end loop;
      else
         for I in 1 .. 8 loop
            pragma Loop_Invariant
              (bs.Current_Bit_Pos =
               bs.Current_Bit_Pos'Loop_Entry + (I - 1) * 8);
            BitStream_AppendByte (bs, tmp (I), False);
         end loop;
      end if;
   end Acn_Enc_Real_IEEE754_64_big_endian;

   procedure Acn_Dec_Real_IEEE754_64_big_endian
     (bs : in out Bitstream; RealVal : out Asn1Real; Result : out ASN1_RESULT)
   is
      tmp : OctetArray8;
      r8  : Long_Float;
   begin
      Result := ASN1_RESULT'(Success => True, ErrorCode => 0);
      if RequiresReverse then
         for I in reverse 1 .. 8 loop
            pragma Loop_Invariant
              (bs.Current_Bit_Pos =
               bs.Current_Bit_Pos'Loop_Entry + (8 - I) * 8);
            BitStream_DecodeByte (bs, tmp (I), Result.Success);
         end loop;
      else
         for I in 1 .. 8 loop
            pragma Loop_Invariant
              (bs.Current_Bit_Pos =
               bs.Current_Bit_Pos'Loop_Entry + (I - 1) * 8);
            BitStream_DecodeByte (bs, tmp (I), Result.Success);
         end loop;
      end if;
      pragma Assert (Result.Success);
      r8      := OctetArray8_to_Long_Float (tmp);
      RealVal := Asn1Real (r8);
   end Acn_Dec_Real_IEEE754_64_big_endian;

   procedure Acn_Enc_Real_IEEE754_32_little_endian
     (bs : in out Bitstream; RealVal : Asn1Real)
   is
      tmp : OctetArray4;
   begin
      tmp := Float_to_OctetArray4 (Long_Float_to_Float (RealVal));
      if not RequiresReverse then
         for i in reverse 1 .. 4 loop
            pragma Loop_Invariant
              (bs.Current_Bit_Pos =
               bs.Current_Bit_Pos'Loop_Entry + (4 - i) * 8);
            BitStream_AppendByte (bs, tmp (i), False);
         end loop;
      else
         for i in 1 .. 4 loop
            pragma Loop_Invariant
              (bs.Current_Bit_Pos =
               bs.Current_Bit_Pos'Loop_Entry + (i - 1) * 8);
            BitStream_AppendByte (bs, tmp (i), False);
         end loop;
      end if;
   end Acn_Enc_Real_IEEE754_32_little_endian;

   procedure Acn_Dec_Real_IEEE754_32_little_endian
     (bs : in out Bitstream; RealVal : out Asn1Real; Result : out ASN1_RESULT)
   is
      tmp : OctetArray4;
   begin
      Result := ASN1_RESULT'(Success => True, ErrorCode => 0);
      if not RequiresReverse then
         for i in reverse 1 .. 4 loop
            pragma Loop_Invariant
              (bs.Current_Bit_Pos =
               bs.Current_Bit_Pos'Loop_Entry + (4 - i) * 8);
            BitStream_DecodeByte (bs, tmp (i), Result.Success);
            pragma Assert (Result.Success);
         end loop;
      else
         for i in 1 .. 4 loop
            pragma Loop_Invariant
              (bs.Current_Bit_Pos =
               bs.Current_Bit_Pos'Loop_Entry + (i - 1) * 8);
            BitStream_DecodeByte (bs, tmp (i), Result.Success);
            pragma Assert (Result.Success);
         end loop;
      end if;
      RealVal := Asn1Real (OctetArray4_to_Float (tmp));
   end Acn_Dec_Real_IEEE754_32_little_endian;

   procedure Acn_Dec_Real_IEEE754_32_little_endian_fp32
     (bs : in out Bitstream; RealVal : out Standard.Float;
       Result : out ASN1_RESULT)
   is
      v : Asn1Real;
   begin
      Acn_Dec_Real_IEEE754_32_little_endian (bs, v, Result);

      pragma Warnings
        (Off, "condition can only be False if invalid values present");
      pragma Warnings
        (Off, "condition is always True");

      Result.Success := Result.Success and then
        Asn1Real (Standard.Float'First) <= v and then
        v <= Asn1Real (Standard.Float'Last);

      pragma Warnings
        (On, "condition can only be False if invalid values present");
      pragma Warnings
        (On, "condition is always True");

      if Result.Success then
         RealVal := Standard.Float (v);
      else
         RealVal := 0.0;
      end if;
   end Acn_Dec_Real_IEEE754_32_little_endian_fp32;

   procedure Acn_Enc_Real_IEEE754_64_little_endian
     (bs : in out Bitstream; RealVal : Asn1Real)
   is
      tmp : OctetArray8;
   begin
      tmp := Long_Float_to_OctetArray8 (Long_Float (RealVal));
      if not RequiresReverse then
         for I in reverse 1 .. 8 loop
            pragma Loop_Invariant
              (bs.Current_Bit_Pos =
               bs.Current_Bit_Pos'Loop_Entry + (8 - I) * 8);
            BitStream_AppendByte (bs, tmp (I), False);
         end loop;
      else
         for I in 1 .. 8 loop
            pragma Loop_Invariant
              (bs.Current_Bit_Pos =
               bs.Current_Bit_Pos'Loop_Entry + (I - 1) * 8);
            BitStream_AppendByte (bs, tmp (I), False);
         end loop;
      end if;
   end Acn_Enc_Real_IEEE754_64_little_endian;

   procedure Acn_Dec_Real_IEEE754_64_little_endian
     (bs : in out Bitstream; RealVal : out Asn1Real; Result : out ASN1_RESULT)
   is
      tmp : OctetArray8;
   begin
      Result := ASN1_RESULT'(Success => True, ErrorCode => 0);
      if not RequiresReverse then
         for I in reverse 1 .. 8 loop
            pragma Loop_Invariant
              (bs.Current_Bit_Pos =
               bs.Current_Bit_Pos'Loop_Entry + (8 - I) * 8);
            BitStream_DecodeByte (bs, tmp (I), Result.Success);
         end loop;
      else
         for I in 1 .. 8 loop
            pragma Loop_Invariant
              (bs.Current_Bit_Pos =
               bs.Current_Bit_Pos'Loop_Entry + (I - 1) * 8);
            BitStream_DecodeByte (bs, tmp (I), Result.Success);
         end loop;
      end if;
      pragma Assert (Result.Success);
      RealVal := Asn1Real (OctetArray8_to_Long_Float (tmp));
   end Acn_Dec_Real_IEEE754_64_little_endian;

   procedure Acn_Enc_Boolean_true_pattern
     (bs : in out Bitstream; BoolVal : Asn1Boolean; pattern : BitArray)
   is
   begin
      for I in Integer range pattern'Range loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos =
            bs.Current_Bit_Pos'Loop_Entry + (I - pattern'First));
         BitStream_AppendBit
           (bs, (if BoolVal then pattern (I) else not pattern (I)));
      end loop;
   end Acn_Enc_Boolean_true_pattern;

   procedure Acn_Dec_Boolean_true_pattern
     (bs     : in out Bitstream; BoolVal : out Asn1Boolean; pattern : BitArray;
      Result :    out ASN1_RESULT)
   is
      bit_val : BIT;
   begin
      BoolVal := True;
      for I in Integer range pattern'Range loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos =
            bs.Current_Bit_Pos'Loop_Entry + (I - pattern'First));
         BitStream_ReadBit (bs, bit_val, Result.Success);
         BoolVal := Result.Success and BoolVal and bit_val = pattern (I);
      end loop;
      Result := ASN1_RESULT'(Success => True, ErrorCode => 0);
   end Acn_Dec_Boolean_true_pattern;

   procedure Acn_Enc_Boolean_false_pattern
     (bs : in out Bitstream; BoolVal : Asn1Boolean; pattern : BitArray)
   is
   begin
      for I in Integer range pattern'Range loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos =
            bs.Current_Bit_Pos'Loop_Entry + (I - pattern'First));
         BitStream_AppendBit
           (bs, (if not BoolVal then pattern (I) else not pattern (I)));
      end loop;
   end Acn_Enc_Boolean_false_pattern;

   procedure Acn_Dec_Boolean_false_pattern
     (bs     : in out Bitstream; BoolVal : out Asn1Boolean; pattern : BitArray;
      Result :    out ASN1_RESULT)
   is
   begin
      Acn_Dec_Boolean_true_pattern (bs, BoolVal, pattern, Result);
      BoolVal := not BoolVal;
   end Acn_Dec_Boolean_false_pattern;

   procedure Acn_Enc_NullType_pattern
     (bs : in out Bitstream; encVal : Asn1NullType; pattern : BitArray)
   is
      pragma Unreferenced (encVal);
   begin
      Acn_Enc_Boolean_true_pattern (bs, True, pattern);
   end Acn_Enc_NullType_pattern;

   procedure Acn_Dec_NullType_pattern
     (bs : in out Bitstream; decValue : out Asn1NullType; pattern : BitArray;
      Result :    out ASN1_RESULT)
   is
      BoolVal : Boolean;
   begin
      Acn_Dec_Boolean_true_pattern (bs, BoolVal, pattern, Result);
      Result.Success := BoolVal;
      decValue       := (if BoolVal then 0 else 1);
   end Acn_Dec_NullType_pattern;

   procedure Acn_Enc_NullType_pattern2
     (bs : in out Bitstream; pattern : BitArray)
   is
   begin
      Acn_Enc_Boolean_true_pattern (bs, True, pattern);
   end Acn_Enc_NullType_pattern2;

   procedure Acn_Dec_NullType_pattern2
     (bs : in out Bitstream; pattern : BitArray; Result : out ASN1_RESULT)
   is
      BoolVal : Boolean;
   begin
      Acn_Dec_Boolean_true_pattern (bs, BoolVal, pattern, Result);
      Result.Success := BoolVal;
   end Acn_Dec_NullType_pattern2;

   procedure Acn_Enc_NullType (bs : in out Bitstream; encVal : Asn1NullType) is
      pragma Unreferenced (bs);
      pragma Unreferenced (encVal);
   begin
      null;
   end Acn_Enc_NullType;

   procedure Acn_Dec_NullType
     (bs     : in out Bitstream; decValue : out Asn1NullType;
      Result :    out ASN1_RESULT)
   is
      pragma Unreferenced (bs);
   begin
      decValue := 0;
      Result   := ASN1_RESULT'(Success => True, ErrorCode => 0);
   end Acn_Dec_NullType;

   procedure Acn_Enc_String_Ascii_FixSize
     (bs : in out Bitstream; strVal : String)
   is
   begin
      for i in strVal'First .. strVal'Last - 1 loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos =
            bs.Current_Bit_Pos'Loop_Entry + (i - strVal'First) * 8);
         BitStream_AppendByte
           (bs, Asn1Byte (CharacterPos (strVal (i))), False);
      end loop;

   end Acn_Enc_String_Ascii_FixSize;

   procedure Acn_Dec_String_Ascii_FixSize
     (bs : in out Bitstream; strVal : in out String; Result : out ASN1_RESULT)
   is
      charIndex : Asn1Byte;
   begin
      Result := ASN1_RESULT'(Success => True, ErrorCode => 0);
      for i in strVal'First .. strVal'Last - 1 loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos =
            bs.Current_Bit_Pos'Loop_Entry + (i - strVal'First) * 8);
         BitStream_DecodeByte (bs, charIndex, Result.Success);
         pragma Assert (Result.Success);
         strVal (i) := Character'Val (Integer (charIndex));
      end loop;
      strVal (strVal'Last) := Standard.Ascii.NUL;
   end Acn_Dec_String_Ascii_FixSize;

   procedure Acn_Enc_String_Ascii_Null_Teminated
     (bs : in out Bitstream; null_characters : OctetBuffer; strVal : String)
   is
      i : Integer := strVal'First;
   begin
      while i <= strVal'Last - 1 and then strVal (i) /= Standard.Ascii.NUL loop
         pragma Loop_Invariant
           (i >= strVal'First and i <= strVal'Last - 1 and
            bs.Current_Bit_Pos =
              bs.Current_Bit_Pos'Loop_Entry + (i - strVal'First) * 8);
         BitStream_AppendByte
           (bs, Asn1Byte (CharacterPos (strVal (i))), False);
         i := i + 1;
      end loop;
      --  encode nullChar
      for i in null_characters'Range loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos =
            bs.Current_Bit_Pos'Loop_Entry + (i - null_characters'First) * 8);
         BitStream_AppendByte (bs, null_characters (i), False);
      end loop;
   end Acn_Enc_String_Ascii_Null_Teminated;

   procedure Acn_Dec_String_Ascii_Null_Teminated
     (bs     : in out Bitstream; null_characters : OctetBuffer;
      strVal : in out String; Result : out ASN1_RESULT)
   is
      I : Integer := strVal'First;
      --  ascii code of 'A'. Let's hope that 'A' will never be null Character
      charIndex : Asn1Byte;
      tmp       : OctetBuffer :=
        OctetBuffer'
          (1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0,
           9 => 0, 10 => 0);
   begin
      Result := ASN1_RESULT'(Success => True, ErrorCode => 0);

      --  read null_character_size characters into the tmp buffer
      pragma Assert (tmp'First = 1);
      pragma Assert (tmp'Last = 10);
      pragma Assert (null_characters'First = 1);
      pragma Assert (null_characters'Last <= 10);

      for i in null_characters'Range loop
         pragma Loop_Invariant
           (bs.Current_Bit_Pos =
            bs.Current_Bit_Pos'Loop_Entry + (i - null_characters'First) * 8 and
            i >= 1 and i <= 10);
         BitStream_DecodeByte (bs, charIndex, Result.Success);
         pragma Assert (Result.Success);
         tmp (i + tmp'First - null_characters'First) := charIndex;
      end loop;

      while I <= strVal'Last - 1
        and then
          null_characters (null_characters'First .. null_characters'Last) /=
          tmp
            (tmp'First ..
                 tmp'First + (null_characters'Last - null_characters'First))
      loop
         pragma Loop_Invariant
           (I >= strVal'First and I <= strVal'Last and
            bs.Current_Bit_Pos =
              bs.Current_Bit_Pos'Loop_Entry + (I - strVal'First) * 8);

         charIndex := tmp (tmp'First);
         for j in null_characters'First .. null_characters'Last - 1 loop
            --  pragma Loop_Invariant (j >= null_characters'First);
            tmp (j + tmp'First - null_characters'First) :=
              tmp (j + 1 + tmp'First - null_characters'First);
         end loop;

         --  BitStream_DecodeByte (bs, digit, Result.Success);
         pragma Assert (null_characters'Last - null_characters'First <= 9);
         BitStream_DecodeByte
           (bs,
            tmp (tmp'First + (null_characters'Last - null_characters'First)),
            Result.Success);
         pragma Assert (Result.Success);

         strVal (I) := Character'Val (Integer (charIndex));

         I := I + 1;
      end loop;

      while I <= strVal'Last loop
         pragma Loop_Invariant (I >= strVal'First and I <= strVal'Last);
         strVal (I) := Standard.Ascii.NUL;
         I          := I + 1;
      end loop;

   end Acn_Dec_String_Ascii_Null_Teminated;

   procedure Acn_Enc_String_Ascii_Internal_Field_Determinant
     (bs                           : in out Bitstream; asn1Min : Asn1Int;
      nLengthDeterminantSizeInBits :        Integer; strVal : String)
   is
      I : Integer := strVal'First;
   begin
      Enc_ConstraintWholeNumber
        (bs, Asn1Int (getStringSize (strVal)), asn1Min,
         nLengthDeterminantSizeInBits);
      while I <= strVal'Last - 1 and then strVal (I) /= Standard.Ascii.NUL loop
         pragma Loop_Invariant
           (I >= strVal'First and I <= strVal'Last and
            bs.Current_Bit_Pos =
              bs.Current_Bit_Pos'Loop_Entry + (I - strVal'First) * 8);
         BitStream_AppendByte
           (bs, Asn1Byte (CharacterPos (strVal (I))), False);

         I := I + 1;
      end loop;

   end Acn_Enc_String_Ascii_Internal_Field_Determinant;

   procedure Acn_Dec_String_Ascii_Internal_Field_Determinant
     (bs : in out Bitstream; asn1Min : Asn1Int; asn1Max : Asn1Int;
      nLengthDeterminantSizeInBits :        Integer; strVal : in out String;
      Result                       :    out ASN1_RESULT)
   is
      I         : Integer := strVal'First;
      nSize     : Integer;
      charIndex : Asn1Byte;
   begin
      Result :=
        ASN1_RESULT'(Success => True, ErrorCode => ERR_INCORRECT_STREAM);

      Dec_ConstraintWholeNumberInt
        (bs, nSize, Integer (asn1Min), Integer (asn1Max),
         nLengthDeterminantSizeInBits, Result.Success);

      while Result.Success and then I <= strVal'Last - 1 and then I <= nSize
      loop
         pragma Loop_Invariant
           (I >= strVal'First and I <= strVal'Last and
            bs.Current_Bit_Pos =
              bs.Current_Bit_Pos'Loop_Entry + (I - strVal'First) * 8);
         BitStream_DecodeByte (bs, charIndex, Result.Success);
         strVal (I) := Character'Val (charIndex);

         I := I + 1;
      end loop;
      while I <= strVal'Last loop
         pragma Loop_Invariant (I >= strVal'First and I <= strVal'Last);
         strVal (I) := Standard.Ascii.NUL;
         I          := I + 1;
      end loop;

   end Acn_Dec_String_Ascii_Internal_Field_Determinant;

   procedure Acn_Enc_String_Ascii_External_Field_Determinant
     (bs : in out Bitstream; strVal : String)
   is
      I : Integer := strVal'First;
   begin
      while I <= strVal'Last - 1 and then strVal (I) /= Standard.Ascii.NUL loop
         pragma Loop_Invariant
           (I >= strVal'First and I <= strVal'Last and
            bs.Current_Bit_Pos =
              bs.Current_Bit_Pos'Loop_Entry + (I - strVal'First) * 8);
         BitStream_AppendByte
           (bs, Asn1Byte (CharacterPos (strVal (I))), False);

         I := I + 1;
      end loop;

   end Acn_Enc_String_Ascii_External_Field_Determinant;

   procedure Acn_Dec_String_Ascii_External_Field_Determinant
     (bs     : in out Bitstream; extSizeDeterminatFld : Asn1Int;
      strVal : in out String; Result : out ASN1_RESULT)
   is
      I         : Integer := strVal'First;
      charIndex : Asn1Byte;
   begin
      Result :=
        ASN1_RESULT'(Success => True, ErrorCode => ERR_INCORRECT_STREAM);

      while Result.Success and then I <= strVal'Last - 1
        and then I <= Integer (extSizeDeterminatFld)
      loop
         pragma Loop_Invariant
           (I >= strVal'First and I <= strVal'Last and
            bs.Current_Bit_Pos =
              bs.Current_Bit_Pos'Loop_Entry + (I - strVal'First) * 8);
         BitStream_DecodeByte (bs, charIndex, Result.Success);
         strVal (I) := Character'Val (Integer (charIndex));

         I := I + 1;
      end loop;
      while I <= strVal'Last loop
         pragma Loop_Invariant (I >= strVal'First and I <= strVal'Last);
         strVal (I) := Standard.Ascii.NUL;
         I          := I + 1;
      end loop;

   end Acn_Dec_String_Ascii_External_Field_Determinant;

   procedure Acn_Enc_String_CharIndex_External_Field_Determinant
     (bs     : in out Bitstream; charSet : String; nCharSize : Integer;
      strVal :        String)
   is
      I         : Integer := strVal'First;
      charIndex : Integer;
   begin
      while I <= strVal'Last - 1 and then strVal (I) /= Standard.Ascii.NUL loop
         pragma Loop_Invariant
           (I >= strVal'First and I <= strVal'Last and
            bs.Current_Bit_Pos =
              bs.Current_Bit_Pos'Loop_Entry + (I - strVal'First) * nCharSize);

         charIndex := GetZeroBasedCharIndex (strVal (I), charSet);
         Enc_ConstraintWholeNumber (bs, Asn1Int (charIndex), 0, nCharSize);

         I := I + 1;
      end loop;

   end Acn_Enc_String_CharIndex_External_Field_Determinant;

   procedure Acn_Dec_String_CharIndex_External_Field_Determinant
     (bs : in out Bitstream; charSet : String; nCharSize : Integer;
      extSizeDeterminatFld :        Asn1Int; strVal : out String;
      Result               :    out ASN1_RESULT)
   is
      I         : Integer          := strVal'First;
      charIndex : Integer;
      asn1Max   : constant Integer := charSet'Last - charSet'First;
   begin
      Result :=
        ASN1_RESULT'(Success => True, ErrorCode => ERR_INCORRECT_STREAM);
      strVal := (others => Standard.Ascii.NUL);
      while Result.Success and then I <= strVal'Last - 1
        and then I <= Integer (extSizeDeterminatFld)
      loop
         pragma Loop_Invariant
           (I >= strVal'First and I <= strVal'Last and
            bs.Current_Bit_Pos =
              bs.Current_Bit_Pos'Loop_Entry + (I - strVal'First) * nCharSize);

         Dec_ConstraintWholeNumberInt
           (bs, charIndex, 0, asn1Max, nCharSize, Result.Success);
         strVal (I) := charSet (charIndex + charSet'First);

         I := I + 1;
      end loop;

      while I <= strVal'Last loop
         pragma Loop_Invariant (I >= strVal'First and I <= strVal'Last);
         strVal (I) := Standard.Ascii.NUL;
         I          := I + 1;
      end loop;

   end Acn_Dec_String_CharIndex_External_Field_Determinant;

   procedure Acn_Enc_String_CharIndex_Internal_Field_Determinant
     (bs      : in out Bitstream; charSet : String; nCharSize : Integer;
      asn1Min :        Asn1Int; nLengthDeterminantSizeInBits : Integer;
      strVal  :        String)
   is
      I         : Integer := strVal'First;
      charIndex : Integer;
   begin
      Enc_ConstraintWholeNumber
        (bs, Asn1Int (getStringSize (strVal)), asn1Min,
         nLengthDeterminantSizeInBits);

      while I <= strVal'Last - 1 and then strVal (I) /= Standard.Ascii.NUL loop
         pragma Loop_Invariant
           (I >= strVal'First and I <= strVal'Last and
            bs.Current_Bit_Pos =
              bs.Current_Bit_Pos'Loop_Entry + (I - strVal'First) * nCharSize);

         charIndex := GetZeroBasedCharIndex (strVal (I), charSet);
         Enc_ConstraintWholeNumber (bs, Asn1Int (charIndex), 0, nCharSize);

         I := I + 1;
      end loop;

   end Acn_Enc_String_CharIndex_Internal_Field_Determinant;

   procedure Acn_Dec_String_CharIndex_Internal_Field_Determinant
     (bs : in out Bitstream; charSet : String; nCharSize : Integer;
      asn1Min                      :        Asn1Int; asn1Max : Asn1Int;
      nLengthDeterminantSizeInBits :        Integer; strVal : in out String;
      Result                       :    out ASN1_RESULT)
   is
      I         : Integer := strVal'First;
      nSize     : Integer;
      charIndex : Integer;
   begin
      Result :=
        ASN1_RESULT'(Success => True, ErrorCode => ERR_INCORRECT_STREAM);

      Dec_ConstraintWholeNumberInt
        (bs, nSize, Integer (asn1Min), Integer (asn1Max),
         nLengthDeterminantSizeInBits, Result.Success);

      while Result.Success and then I <= strVal'Last - 1 and then I <= nSize
      loop
         pragma Loop_Invariant
           (I >= strVal'First and I <= strVal'Last and
            bs.Current_Bit_Pos =
              bs.Current_Bit_Pos'Loop_Entry + (I - strVal'First) * nCharSize);

         Dec_ConstraintWholeNumberInt
           (bs, charIndex, 0, Integer (asn1Max), nCharSize, Result.Success);
         if Result.Success and charIndex + charSet'First <= charSet'Last then
            strVal (I) := charSet (charIndex + charSet'First);
         else
            Result.Success := False;
            strVal (I)     := Standard.Ascii.NUL;
         end if;

         I := I + 1;
      end loop;

      while I <= strVal'Last loop
         pragma Loop_Invariant (I >= strVal'First and I <= strVal'Last);
         strVal (I) := Standard.Ascii.NUL;
         I          := I + 1;
      end loop;

   end Acn_Dec_String_CharIndex_Internal_Field_Determinant;

   procedure Acn_Dec_Int_PositiveInteger_ConstSizeUInt8
     (bs : in out Bitstream; IntVal : out Unsigned_8; MinVal : Unsigned_8;
      MaxVal : Unsigned_8; nBits : Integer; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize (bs, v, Asn1UInt (MinVal),
             Asn1UInt (MaxVal), nBits, Result);

      IntVal := Unsigned_8 (v);
   end Acn_Dec_Int_PositiveInteger_ConstSizeUInt8;

   procedure Acn_Dec_Int_PositiveInteger_ConstSizeUInt16
     (bs : in out Bitstream; IntVal : out Unsigned_16; MinVal : Unsigned_16;
      MaxVal : Unsigned_16; nBits : Integer; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize (bs, v, Asn1UInt (MinVal),
             Asn1UInt (MaxVal), nBits, Result);

      IntVal := Unsigned_16 (v);
   end Acn_Dec_Int_PositiveInteger_ConstSizeUInt16;

   procedure Acn_Dec_Int_PositiveInteger_ConstSizeUInt32
     (bs : in out Bitstream; IntVal : out Unsigned_32; MinVal : Unsigned_32;
      MaxVal : Unsigned_32; nBits : Integer; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize (bs, v, Asn1UInt (MinVal),
             Asn1UInt (MaxVal), nBits, Result);

      IntVal := Unsigned_32 (v);
   end Acn_Dec_Int_PositiveInteger_ConstSizeUInt32;

   procedure Acn_Dec_Int_TwosComplement_ConstSizeInt8
     (bs : in out Bitstream; IntVal : out Integer_8; MinVal : Integer_8;
      MaxVal : Integer_8; nBits : Integer; Result : out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_TwosComplement_ConstSize (bs, v, Asn1Int (MinVal),
             Asn1Int (MaxVal), nBits, Result);

      IntVal := Integer_8 (v);
   end Acn_Dec_Int_TwosComplement_ConstSizeInt8;

   procedure Acn_Dec_Int_TwosComplement_ConstSizeInt16
     (bs : in out Bitstream; IntVal : out Integer_16; MinVal : Integer_16;
      MaxVal : Integer_16; nBits : Integer; Result : out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_TwosComplement_ConstSize (bs, v, Asn1Int (MinVal),
             Asn1Int (MaxVal), nBits, Result);

      IntVal := Integer_16 (v);
   end Acn_Dec_Int_TwosComplement_ConstSizeInt16;

   procedure Acn_Dec_Int_TwosComplement_ConstSizeInt32
     (bs : in out Bitstream; IntVal : out Integer_32; MinVal : Integer_32;
      MaxVal : Integer_32; nBits : Integer; Result : out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_TwosComplement_ConstSize (bs, v, Asn1Int (MinVal),
             Asn1Int (MaxVal), nBits, Result);

      IntVal := Integer_32 (v);
   end Acn_Dec_Int_TwosComplement_ConstSizeInt32;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_8UInt8
     (bs : in out Bitstream; IntVal : out Unsigned_8; MinVal : Unsigned_8;
      MaxVal : Unsigned_8; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize_8 (bs, v,
         Asn1UInt (MinVal), Asn1UInt (MaxVal), Result);

      IntVal := Unsigned_8 (v);
   end Acn_Dec_Int_PositiveInteger_ConstSize_8UInt8;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_16UInt16
     (bs : in out Bitstream; IntVal : out Unsigned_16; MinVal : Unsigned_16;
      MaxVal : Unsigned_16; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_16 (bs, v,
         Asn1UInt (MinVal), Asn1UInt (MaxVal), Result);

      IntVal := Unsigned_16 (v);
   end Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_16UInt16;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_16UInt8
     (bs : in out Bitstream; IntVal : out Unsigned_8; MinVal : Unsigned_8;
      MaxVal : Unsigned_8; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_16 (bs, v,
         Asn1UInt (MinVal), Asn1UInt (MaxVal), Result);

      IntVal := Unsigned_8 (v);
   end Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_16UInt8;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_32UInt32
     (bs : in out Bitstream; IntVal : out Unsigned_32; MinVal : Unsigned_32;
      MaxVal : Unsigned_32; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_32 (bs, v,
         Asn1UInt (MinVal), Asn1UInt (MaxVal), Result);

      IntVal := Unsigned_32 (v);
   end Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_32UInt32;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_32UInt16
     (bs : in out Bitstream; IntVal : out Unsigned_16; MinVal : Unsigned_16;
      MaxVal : Unsigned_16; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_32 (bs, v,
         Asn1UInt (MinVal), Asn1UInt (MaxVal), Result);

      IntVal := Unsigned_16 (v);
   end Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_32UInt16;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_32UInt8
     (bs : in out Bitstream; IntVal : out Unsigned_8; MinVal : Unsigned_8;
      MaxVal : Unsigned_8; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_32 (bs, v,
         Asn1UInt (MinVal), Asn1UInt (MaxVal), Result);

      IntVal := Unsigned_8 (v);
   end Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_32UInt8;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_64UInt32
     (bs : in out Bitstream; IntVal : out Unsigned_32; MinVal : Unsigned_32;
      MaxVal : Unsigned_32; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_64 (bs, v,
         Asn1UInt (MinVal), Asn1UInt (MaxVal), Result);

      IntVal := Unsigned_32 (v);
   end Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_64UInt32;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_64UInt16
     (bs : in out Bitstream; IntVal : out Unsigned_16; MinVal : Unsigned_16;
      MaxVal : Unsigned_16; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_64 (bs, v,
         Asn1UInt (MinVal), Asn1UInt (MaxVal), Result);

      IntVal := Unsigned_16 (v);
   end Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_64UInt16;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_64UInt8
     (bs : in out Bitstream; IntVal : out Unsigned_8; MinVal : Unsigned_8;
      MaxVal : Unsigned_8; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_64 (bs, v,
         Asn1UInt (MinVal), Asn1UInt (MaxVal), Result);

      IntVal := Unsigned_8 (v);
   end Acn_Dec_Int_PositiveInteger_ConstSize_big_endian_64UInt8;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_16UInt16
     (bs : in out Bitstream; IntVal : out Unsigned_16; MinVal : Unsigned_16;
      MaxVal : Unsigned_16; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_16 (bs, v,
         Asn1UInt (MinVal), Asn1UInt (MaxVal), Result);

      IntVal := Unsigned_16 (v);
   end Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_16UInt16;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_16UInt8
     (bs : in out Bitstream; IntVal : out Unsigned_8; MinVal : Unsigned_8;
      MaxVal : Unsigned_8; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_16 (bs, v,
         Asn1UInt (MinVal), Asn1UInt (MaxVal), Result);

      IntVal := Unsigned_8 (v);
   end Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_16UInt8;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_32UInt32
     (bs : in out Bitstream; IntVal : out Unsigned_32; MinVal : Unsigned_32;
      MaxVal : Unsigned_32; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_32 (bs, v,
         Asn1UInt (MinVal), Asn1UInt (MaxVal), Result);

      IntVal := Unsigned_32 (v);
   end Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_32UInt32;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_32UInt16
     (bs : in out Bitstream; IntVal : out Unsigned_16; MinVal : Unsigned_16;
      MaxVal : Unsigned_16; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_32 (bs, v,
         Asn1UInt (MinVal), Asn1UInt (MaxVal), Result);

      IntVal := Unsigned_16 (v);
   end Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_32UInt16;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_32UInt8
     (bs : in out Bitstream; IntVal : out Unsigned_8; MinVal : Unsigned_8;
      MaxVal : Unsigned_8; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_32 (bs, v,
         Asn1UInt (MinVal), Asn1UInt (MaxVal), Result);

      IntVal := Unsigned_8 (v);
   end Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_32UInt8;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_64UInt32
     (bs : in out Bitstream; IntVal : out Unsigned_32; MinVal : Unsigned_32;
      MaxVal : Unsigned_32; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_64 (bs, v,
         Asn1UInt (MinVal), Asn1UInt (MaxVal), Result);

      IntVal := Unsigned_32 (v);
   end Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_64UInt32;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_64UInt16
     (bs : in out Bitstream; IntVal : out Unsigned_16; MinVal : Unsigned_16;
      MaxVal : Unsigned_16; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_64 (bs, v,
         Asn1UInt (MinVal), Asn1UInt (MaxVal), Result);

      IntVal := Unsigned_16 (v);
   end Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_64UInt16;

   procedure Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_64UInt8
     (bs : in out Bitstream; IntVal : out Unsigned_8; MinVal : Unsigned_8;
      MaxVal : Unsigned_8; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_64 (bs, v,
         Asn1UInt (MinVal), Asn1UInt (MaxVal), Result);

      IntVal := Unsigned_8 (v);
   end Acn_Dec_Int_PositiveInteger_ConstSize_little_endian_64UInt8;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_8Int8
     (bs : in out Bitstream; IntVal : out Integer_8; MinVal : Integer_8;
      MaxVal : Integer_8; Result : out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_TwosComplement_ConstSize_8 (bs, v,
         Asn1Int (MinVal), Asn1Int (MaxVal), Result);

      IntVal := Integer_8 (v);
   end Acn_Dec_Int_TwosComplement_ConstSize_8Int8;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_big_endian_16Int16
     (bs : in out Bitstream; IntVal : out Integer_16; MinVal : Integer_16;
      MaxVal : Integer_16; Result : out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_TwosComplement_ConstSize_big_endian_16 (bs, v,
         Asn1Int (MinVal), Asn1Int (MaxVal), Result);

      IntVal := Integer_16 (v);
   end Acn_Dec_Int_TwosComplement_ConstSize_big_endian_16Int16;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_big_endian_16Int8
     (bs : in out Bitstream; IntVal : out Integer_8; MinVal : Integer_8;
      MaxVal : Integer_8; Result : out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_TwosComplement_ConstSize_big_endian_16 (bs, v,
         Asn1Int (MinVal), Asn1Int (MaxVal), Result);

      IntVal := Integer_8 (v);
   end Acn_Dec_Int_TwosComplement_ConstSize_big_endian_16Int8;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_big_endian_32Int32
     (bs : in out Bitstream; IntVal : out Integer_32; MinVal : Integer_32;
      MaxVal : Integer_32; Result : out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_TwosComplement_ConstSize_big_endian_32 (bs, v,
         Asn1Int (MinVal), Asn1Int (MaxVal), Result);

      IntVal := Integer_32 (v);
   end Acn_Dec_Int_TwosComplement_ConstSize_big_endian_32Int32;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_big_endian_32Int16
     (bs : in out Bitstream; IntVal : out Integer_16; MinVal : Integer_16;
      MaxVal : Integer_16; Result : out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_TwosComplement_ConstSize_big_endian_32 (bs, v,
         Asn1Int (MinVal), Asn1Int (MaxVal), Result);

      IntVal := Integer_16 (v);
   end Acn_Dec_Int_TwosComplement_ConstSize_big_endian_32Int16;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_big_endian_32Int8
     (bs : in out Bitstream; IntVal : out Integer_8; MinVal : Integer_8;
      MaxVal : Integer_8; Result : out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_TwosComplement_ConstSize_big_endian_32 (bs, v,
         Asn1Int (MinVal), Asn1Int (MaxVal), Result);

      IntVal := Integer_8 (v);
   end Acn_Dec_Int_TwosComplement_ConstSize_big_endian_32Int8;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_big_endian_64Int32
     (bs : in out Bitstream; IntVal : out Integer_32; MinVal : Integer_32;
      MaxVal : Integer_32; Result : out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_TwosComplement_ConstSize_big_endian_64 (bs, v,
         Asn1Int (MinVal), Asn1Int (MaxVal), Result);

      IntVal := Integer_32 (v);
   end Acn_Dec_Int_TwosComplement_ConstSize_big_endian_64Int32;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_big_endian_64Int16
     (bs : in out Bitstream; IntVal : out Integer_16; MinVal : Integer_16;
      MaxVal : Integer_16; Result : out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_TwosComplement_ConstSize_big_endian_64 (bs, v,
         Asn1Int (MinVal), Asn1Int (MaxVal), Result);

      IntVal := Integer_16 (v);
   end Acn_Dec_Int_TwosComplement_ConstSize_big_endian_64Int16;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_big_endian_64Int8
     (bs : in out Bitstream; IntVal : out Integer_8; MinVal : Integer_8;
      MaxVal : Integer_8; Result : out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_TwosComplement_ConstSize_big_endian_64 (bs, v,
         Asn1Int (MinVal), Asn1Int (MaxVal), Result);

      IntVal := Integer_8 (v);
   end Acn_Dec_Int_TwosComplement_ConstSize_big_endian_64Int8;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_little_endian_16Int16
     (bs : in out Bitstream; IntVal : out Integer_16; MinVal : Integer_16;
      MaxVal : Integer_16; Result : out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_TwosComplement_ConstSize_little_endian_16 (bs, v,
         Asn1Int (MinVal), Asn1Int (MaxVal), Result);

      IntVal := Integer_16 (v);
   end Acn_Dec_Int_TwosComplement_ConstSize_little_endian_16Int16;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_little_endian_16Int8
     (bs : in out Bitstream; IntVal : out Integer_8; MinVal : Integer_8;
      MaxVal : Integer_8; Result : out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_TwosComplement_ConstSize_little_endian_16 (bs, v,
         Asn1Int (MinVal), Asn1Int (MaxVal), Result);

      IntVal := Integer_8 (v);
   end Acn_Dec_Int_TwosComplement_ConstSize_little_endian_16Int8;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_little_endian_32Int32
     (bs : in out Bitstream; IntVal : out Integer_32; MinVal : Integer_32;
      MaxVal : Integer_32; Result : out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_TwosComplement_ConstSize_little_endian_32 (bs, v,
         Asn1Int (MinVal), Asn1Int (MaxVal), Result);

      IntVal := Integer_32 (v);
   end Acn_Dec_Int_TwosComplement_ConstSize_little_endian_32Int32;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_little_endian_32Int16
     (bs : in out Bitstream; IntVal : out Integer_16; MinVal : Integer_16;
      MaxVal : Integer_16; Result : out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_TwosComplement_ConstSize_little_endian_32 (bs, v,
         Asn1Int (MinVal), Asn1Int (MaxVal), Result);

      IntVal := Integer_16 (v);
   end Acn_Dec_Int_TwosComplement_ConstSize_little_endian_32Int16;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_little_endian_32Int8
     (bs : in out Bitstream; IntVal : out Integer_8; MinVal : Integer_8;
      MaxVal : Integer_8; Result : out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_TwosComplement_ConstSize_little_endian_32 (bs, v,
         Asn1Int (MinVal), Asn1Int (MaxVal), Result);

      IntVal := Integer_8 (v);
   end Acn_Dec_Int_TwosComplement_ConstSize_little_endian_32Int8;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_little_endian_64Int32
     (bs : in out Bitstream; IntVal : out Integer_32; MinVal : Integer_32;
      MaxVal : Integer_32; Result : out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_TwosComplement_ConstSize_little_endian_64 (bs, v,
         Asn1Int (MinVal), Asn1Int (MaxVal), Result);

      IntVal := Integer_32 (v);
   end Acn_Dec_Int_TwosComplement_ConstSize_little_endian_64Int32;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_little_endian_64Int16
     (bs : in out Bitstream; IntVal : out Integer_16; MinVal : Integer_16;
      MaxVal : Integer_16; Result : out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_TwosComplement_ConstSize_little_endian_64 (bs, v,
         Asn1Int (MinVal), Asn1Int (MaxVal), Result);

      IntVal := Integer_16 (v);
   end Acn_Dec_Int_TwosComplement_ConstSize_little_endian_64Int16;

   procedure Acn_Dec_Int_TwosComplement_ConstSize_little_endian_64Int8
     (bs : in out Bitstream; IntVal : out Integer_8; MinVal : Integer_8;
      MaxVal : Integer_8; Result : out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_TwosComplement_ConstSize_little_endian_64 (bs, v,
         Asn1Int (MinVal), Asn1Int (MaxVal), Result);

      IntVal := Integer_8 (v);
   end Acn_Dec_Int_TwosComplement_ConstSize_little_endian_64Int8;

   procedure Acn_Dec_Int_BCD_ConstSizeUInt8
     (bs : in out Bitstream; IntVal : out Unsigned_8; minVal : Unsigned_8;
      maxVal : Unsigned_8; nNibbles : Integer; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_BCD_ConstSize (bs, v, Asn1UInt (minVal),
             Asn1UInt (maxVal), nNibbles, Result);

      IntVal := Unsigned_8 (v);
   end Acn_Dec_Int_BCD_ConstSizeUInt8;

   procedure Acn_Dec_Int_BCD_ConstSizeUInt16
     (bs : in out Bitstream; IntVal : out Unsigned_16; minVal : Unsigned_16;
      maxVal : Unsigned_16; nNibbles : Integer; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_BCD_ConstSize (bs, v, Asn1UInt (minVal),
             Asn1UInt (maxVal), nNibbles, Result);

      IntVal := Unsigned_16 (v);
   end Acn_Dec_Int_BCD_ConstSizeUInt16;

   procedure Acn_Dec_Int_BCD_ConstSizeUInt32
     (bs : in out Bitstream; IntVal : out Unsigned_32; minVal : Unsigned_32;
      maxVal : Unsigned_32; nNibbles : Integer; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_BCD_ConstSize (bs, v, Asn1UInt (minVal),
             Asn1UInt (maxVal), nNibbles, Result);

      IntVal := Unsigned_32 (v);
   end Acn_Dec_Int_BCD_ConstSizeUInt32;

   procedure Acn_Dec_Int_BCD_VarSize_NullTerminatedUInt8
     (bs : in out Bitstream; IntVal : out Unsigned_8; minVal : Unsigned_8;
      maxVal : Unsigned_8; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_BCD_VarSize_NullTerminated (bs, v, Asn1UInt (minVal),
             Asn1UInt (maxVal), Result);

      IntVal := Unsigned_8 (v);
   end Acn_Dec_Int_BCD_VarSize_NullTerminatedUInt8;

   procedure Acn_Dec_Int_BCD_VarSize_NullTerminatedUInt16
     (bs : in out Bitstream; IntVal : out Unsigned_16; minVal : Unsigned_16;
      maxVal : Unsigned_16; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_BCD_VarSize_NullTerminated (bs, v, Asn1UInt (minVal),
             Asn1UInt (maxVal), Result);

      IntVal := Unsigned_16 (v);
   end Acn_Dec_Int_BCD_VarSize_NullTerminatedUInt16;

   procedure Acn_Dec_Int_BCD_VarSize_NullTerminatedUInt32
     (bs : in out Bitstream; IntVal : out Unsigned_32; minVal : Unsigned_32;
      maxVal : Unsigned_32; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_Int_BCD_VarSize_NullTerminated (bs, v, Asn1UInt (minVal),
             Asn1UInt (maxVal), Result);

      IntVal := Unsigned_32 (v);
   end Acn_Dec_Int_BCD_VarSize_NullTerminatedUInt32;

   procedure Acn_Dec_Int_ASCII_ConstSizeInt8
     (bs : in out Bitstream; IntVal : out Integer_8; minVal : Integer_8;
      maxVal : Integer_8; nChars : Integer; Result : out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_ASCII_ConstSize (bs, v, Asn1Int (minVal),
             Asn1Int (maxVal), nChars, Result);

      IntVal := Integer_8 (v);
   end Acn_Dec_Int_ASCII_ConstSizeInt8;

   procedure Acn_Dec_Int_ASCII_ConstSizeInt16
     (bs : in out Bitstream; IntVal : out Integer_16; minVal : Integer_16;
      maxVal : Integer_16; nChars : Integer; Result : out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_ASCII_ConstSize (bs, v, Asn1Int (minVal),
             Asn1Int (maxVal), nChars, Result);

      IntVal := Integer_16 (v);
   end Acn_Dec_Int_ASCII_ConstSizeInt16;

   procedure Acn_Dec_Int_ASCII_ConstSizeInt32
     (bs : in out Bitstream; IntVal : out Integer_32; minVal : Integer_32;
      maxVal : Integer_32; nChars : Integer; Result : out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_ASCII_ConstSize (bs, v, Asn1Int (minVal),
             Asn1Int (maxVal), nChars, Result);

      IntVal := Integer_32 (v);
   end Acn_Dec_Int_ASCII_ConstSizeInt32;

   procedure Acn_Dec_UInt_ASCII_ConstSizeUInt8
     (bs : in out Bitstream; IntVal : out Unsigned_8; minVal : Unsigned_8;
      maxVal : Unsigned_8; nChars : Integer; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_UInt_ASCII_ConstSize (bs, v, Asn1UInt (minVal),
             Asn1UInt (maxVal), nChars, Result);

      IntVal := Unsigned_8 (v);
   end Acn_Dec_UInt_ASCII_ConstSizeUInt8;

   procedure Acn_Dec_UInt_ASCII_ConstSizeUInt16
     (bs : in out Bitstream; IntVal : out Unsigned_16; minVal : Unsigned_16;
      maxVal : Unsigned_16; nChars : Integer; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_UInt_ASCII_ConstSize (bs, v, Asn1UInt (minVal),
             Asn1UInt (maxVal), nChars, Result);

      IntVal := Unsigned_16 (v);
   end Acn_Dec_UInt_ASCII_ConstSizeUInt16;

   procedure Acn_Dec_UInt_ASCII_ConstSizeUInt32
     (bs : in out Bitstream; IntVal : out Unsigned_32; minVal : Unsigned_32;
      maxVal : Unsigned_32; nChars : Integer; Result : out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_UInt_ASCII_ConstSize (bs, v, Asn1UInt (minVal),
             Asn1UInt (maxVal), nChars, Result);

      IntVal := Unsigned_32 (v);
   end Acn_Dec_UInt_ASCII_ConstSizeUInt32;

   procedure Acn_Dec_Int_ASCII_VarSize_NullTerminatedInt8
     (bs : in out Bitstream; IntVal : out Integer_8;
      nullChars : OctetBuffer; Result :    out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_ASCII_VarSize_NullTerminated (bs, v,
             nullChars, Result);
      Result.Success := Result.Success and then
        Asn1Int (Integer_8'First) <= v and then v <= Asn1Int (Integer_8'Last);

      if Result.Success then
         IntVal := Integer_8 (v);
      else
         IntVal := 0;
      end if;

   end Acn_Dec_Int_ASCII_VarSize_NullTerminatedInt8;

   procedure Acn_Dec_Int_ASCII_VarSize_NullTerminatedInt16
     (bs : in out Bitstream; IntVal : out Integer_16;
      nullChars : OctetBuffer; Result :    out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_ASCII_VarSize_NullTerminated (bs, v,
             nullChars, Result);
      Result.Success := Result.Success and then
        Asn1Int (Integer_16'First) <= v and then
        v <= Asn1Int (Integer_16'Last);

      if Result.Success then
         IntVal := Integer_16 (v);
      else
         IntVal := 0;
      end if;

   end Acn_Dec_Int_ASCII_VarSize_NullTerminatedInt16;

   procedure Acn_Dec_Int_ASCII_VarSize_NullTerminatedInt32
     (bs : in out Bitstream; IntVal : out Integer_32;
      nullChars : OctetBuffer; Result :    out ASN1_RESULT)
   is
      v : Asn1Int;
   begin
      Acn_Dec_Int_ASCII_VarSize_NullTerminated (bs, v,
                                                nullChars, Result);
      pragma Warnings
        (Off, "condition can only be False if invalid values present");
      pragma Warnings
        (Off, "condition is always True");

      Result.Success := Result.Success and then
        Asn1Int (Integer_32'First) <= v and then
        v <= Asn1Int (Integer_32'Last);

      pragma Warnings
        (On, "condition can only be False if invalid values present");
      pragma Warnings
        (On, "condition is always True");

      if Result.Success then
         IntVal := Integer_32 (v);
      else
         IntVal := 0;
      end if;

   end Acn_Dec_Int_ASCII_VarSize_NullTerminatedInt32;

   procedure Acn_Dec_UInt_ASCII_VarSize_NullTerminatedUInt8
     (bs : in out Bitstream; IntVal : out Unsigned_8;
      nullChars : OctetBuffer; Result :    out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_UInt_ASCII_VarSize_NullTerminated (bs, v,
             nullChars, Result);
      Result.Success := Result.Success and then
        v <= Asn1UInt (Unsigned_8'Last);

      if Result.Success then
         IntVal := Unsigned_8 (v);
      else
         IntVal := 0;
      end if;

   end Acn_Dec_UInt_ASCII_VarSize_NullTerminatedUInt8;

   procedure Acn_Dec_UInt_ASCII_VarSize_NullTerminatedUInt16
     (bs : in out Bitstream; IntVal : out Unsigned_16;
      nullChars : OctetBuffer; Result :    out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_UInt_ASCII_VarSize_NullTerminated (bs, v,
             nullChars, Result);
      Result.Success := Result.Success and then
         v <= Asn1UInt (Unsigned_16'Last);

      if Result.Success then
         IntVal := Unsigned_16 (v);
      else
         IntVal := 0;
      end if;

   end Acn_Dec_UInt_ASCII_VarSize_NullTerminatedUInt16;

   procedure Acn_Dec_UInt_ASCII_VarSize_NullTerminatedUInt32
     (bs : in out Bitstream; IntVal : out Unsigned_32;
      nullChars : OctetBuffer; Result :    out ASN1_RESULT)
   is
      v : Asn1UInt;
   begin
      Acn_Dec_UInt_ASCII_VarSize_NullTerminated (bs, v,
                                                 nullChars, Result);
      pragma Warnings
        (Off, "condition can only be False if invalid values present");
      pragma Warnings
        (Off, "condition is always True");

      Result.Success := Result.Success and then
        v <= Asn1UInt (Unsigned_32'Last);

      pragma Warnings
        (On, "condition can only be False if invalid values present");
      pragma Warnings
        (On, "condition is always True");

      if Result.Success then
         IntVal := Unsigned_32 (v);
      else
         IntVal := 0;
      end if;

   end Acn_Dec_UInt_ASCII_VarSize_NullTerminatedUInt32;

end adaasn1rtl.encoding.acn;
