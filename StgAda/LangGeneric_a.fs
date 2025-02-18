﻿module LangGeneric_a
open CommonTypes
open System.Numerics
open DAst
open FsUtils
open Language
open System.IO

(****** Ada Implementation ******)

let getAccess_a  (_:FuncParamType) = "."
#if false
let createBitStringFunction_funcBody_Ada handleFragmentation (codec:CommonTypes.Codec) (id : ReferenceToType) (typeDefinition:TypeDefintionOrReference) isFixedSize  uperMaxSizeInBits minSize maxSize (errCode:ErroCode) (p:CallerScope) = 
    let ii = id.SeqeuenceOfLevel + 1;
    let i = sprintf "i%d" (id.SeqeuenceOfLevel + 1)

    let typeDefinitionName =
        match typeDefinition with
        | TypeDefinition  td ->
            td.typedefName
        | ReferenceToExistingDefinition ref ->
            match ref.programUnit with
            | Some pu -> pu + "." + ref.typedefName
            | None    -> ref.typedefName

    let funcBodyContent, localVariables = 
        let nStringLength = 
            match isFixedSize with  
            | true  -> [] 
            | false -> 
                match codec with
                | Encode    -> []
                | Decode    -> [IntegerLocalVariable ("nStringLength", None)]
        let iVar = SequenceOfIndex (id.SeqeuenceOfLevel + 1, None)

        let nBits = 1I
        let internalItem = uper_a.InternalItem_bit_str p.arg.p i  errCode.errCodeName codec 
        let nSizeInBits = GetNumberOfBitsForNonNegativeInteger ( (maxSize - minSize))
        match minSize with
        | _ when maxSize < 65536I && isFixedSize  -> uper_a.octect_FixedSize p.arg.p typeDefinitionName i internalItem (minSize) nBits nBits 0I codec, iVar::nStringLength 
        | _ when maxSize < 65536I && (not isFixedSize) -> uper_a.octect_VarSize p.arg.p "."  typeDefinitionName i internalItem ( minSize) (maxSize) nSizeInBits nBits nBits 0I errCode.errCodeName codec , iVar::nStringLength
        | _                                                -> 
            let funcBodyContent, fragmentationLvars = handleFragmentation p codec errCode ii (uperMaxSizeInBits) minSize maxSize internalItem nBits true false
            let fragmentationLvars = fragmentationLvars |> List.addIf (not isFixedSize) (iVar)
            (funcBodyContent,fragmentationLvars)

    {UPERFuncBodyResult.funcBody = funcBodyContent; errCodes = [errCode]; localVariables = localVariables; bValIsUnReferenced=false; bBsIsUnReferenced=false}    
#endif




//let getBoardDirs (l:ProgrammingLanguage) target =
//    getBoardNames l target |> List.map(fun s -> Path.Combine(boardsDirName l target , s))

type LangBasic_ada() =
    inherit ILangBasic()
        override this.cmp (s1:string) (s2:string) = s1.icompare s2
        override this.keywords = ada_keyworkds
        override this.OnTypeNameConflictTryAppendModName = false
        override this.declare_IntegerNoRTL = "adaasn1rtl", "Asn1Int", "INTEGER"
        override this.declare_PosIntegerNoRTL = "adaasn1rtl", "Asn1UInt" , "INTEGER"
        override this.getRealRtlTypeName   = "adaasn1rtl", "Asn1Real", "REAL"
        override this.getObjectIdentifierRtlTypeName  relativeId = 
            let asn1Name = if relativeId then "RELATIVE-OID" else "OBJECT IDENTIFIER"
            "adaasn1rtl", "Asn1ObjectIdentifier", asn1Name

        override this.getTimeRtlTypeName  timeClass = 
            let asn1Name = "TIME"
            match timeClass with 
            | Asn1LocalTime                    _ -> "adaasn1rtl", "Asn1LocalTime", asn1Name
            | Asn1UtcTime                      _ -> "adaasn1rtl", "Asn1UtcTime", asn1Name
            | Asn1LocalTimeWithTimeZone        _ -> "adaasn1rtl", "Asn1TimeWithTimeZone", asn1Name
            | Asn1Date                           -> "adaasn1rtl", "Asn1Date", asn1Name
            | Asn1Date_LocalTime               _ -> "adaasn1rtl", "Asn1DateLocalTime", asn1Name
            | Asn1Date_UtcTime                 _ -> "adaasn1rtl", "Asn1DateUtcTime", asn1Name
            | Asn1Date_LocalTimeWithTimeZone   _ -> "adaasn1rtl", "Asn1DateTimeWithTimeZone", asn1Name
        override this.getNullRtlTypeName  = "adaasn1rtl", "Asn1NullType", "NULL"
        override this.getBoolRtlTypeName = "adaasn1rtl", "Asn1Boolean", "BOOLEAN"




type LangGeneric_a() =
    inherit ILangGeneric()
        override _.ArrayStartIndex = 1
        override this.getEmptySequenceInitExpression () = "(null record)"
        override this.callFuncWithNoArgs () = ""

        override this.rtlModuleName  = "adaasn1rtl."
        override this.AssignOperator = ":="
        override this.TrueLiteral = "True"
        override this.FalseLiteral = "False"
        override this.hasModules = true
        override this.allowsSrcFilesWithNoFunctions = false
        override this.requiresValueAssignmentsInSrcFile = false
        override this.supportsStaticVerification = true 
        override this.emtyStatement = "null;"
        override this.bitStreamName = "adaasn1rtl.encoding.BitStreamPtr"
        override this.unaryNotOperator    = "not"
        override this.modOp               = "mod"
        override this.eqOp                = "="
        override this.neqOp               = "<>"
        override this.andOp               = "and"
        override this.orOp                = "or"
        override this.initMetod           = InitMethod.Function

        override this.castExpression (sExp:string) (sCastType:string) = sprintf "%s(%s)" sCastType sExp
        override this.createSingleLineComment (sText:string) = sprintf "--%s" sText

        override _.SpecNameSuffix = ""
        override _.SpecExtention = "ads"
        override _.BodyExtention = "adb"
        override _.Keywords  = CommonTypes.ada_keyworkds
        override _.isCaseSensitive = false


        override _.doubleValueToString (v:double) = 
            v.ToString(FsUtils.doubleParseString, System.Globalization.NumberFormatInfo.InvariantInfo)
        override _.intValueToString (i:BigInteger) _ = i.ToString()

        override _.initializeString (_) = "(others => adaasn1rtl.NUL)"
        
        override _.supportsInitExpressions = true

        override _.getPointer  (fpt:FuncParamType) =
            match fpt with
            | VALUE x      -> x
            | POINTER x    -> x
            | FIXARRAY x   -> x

        override this.getValue  (fpt:FuncParamType) =
            match fpt with
            | VALUE x      -> x
            | POINTER x    -> x
            | FIXARRAY x   -> x
        override this.getAccess  (fpt:FuncParamType) = getAccess_a fpt

        override this.getPtrPrefix (fpt: FuncParamType) = 
            match fpt with
            | VALUE x        -> ""
            | POINTER x      -> ""
            | FIXARRAY x     -> ""

        override this.getPtrSuffix (fpt: FuncParamType) = 
            match fpt with
            | VALUE x        -> ""
            | POINTER x      -> ""
            | FIXARRAY x     -> ""

        override this.getStar  (fpt:FuncParamType) =
            match fpt with
            | VALUE x        -> ""
            | POINTER x      -> ""
            | FIXARRAY x     -> ""

        override this.getArrayItem (fpt:FuncParamType) (idx:string) (childTypeIsString: bool) =
            let newPath = sprintf "%s.Data(%s)" fpt.p idx
            if childTypeIsString then (FIXARRAY newPath) else (VALUE newPath)
        override this.ArrayAccess idx = "(" + idx + ")"

        override this.choiceIDForNone (typeIdsSet:Map<string,int>) (id:ReferenceToType) =  
            let prefix = ToC (id.AcnAbsPath.Tail.StrJoin("_").Replace("#","elem"))
            prefix + "_NONE"


        override this.getNamedItemBackendName (defOrRef:TypeDefintionOrReference option) (nm:Asn1AcnAst.NamedItem) = 
            match defOrRef with
            | Some (ReferenceToExistingDefinition r) when r.programUnit.IsSome -> r.programUnit.Value + "." + nm.ada_name
            | Some (TypeDefinition td) when td.baseType.IsSome && td.baseType.Value.programUnit.IsSome  -> td.baseType.Value.programUnit.Value + "." + nm.ada_name
            | _       -> ToC nm.ada_name
        
        override this.setNamedItemBackendName0 (nm:Asn1Ast.NamedItem) (newValue:string) : Asn1Ast.NamedItem =
            {nm with ada_name = newValue}
        override this.getNamedItemBackendName0 (nm:Asn1Ast.NamedItem)  = nm.ada_name
        
        override this.getNamedItemBackendName2 (defModule:string) (curProgamUnitName:string) (itm:Asn1AcnAst.NamedItem) = 
            
            match (ToC defModule) = ToC curProgamUnitName with
            | true  -> ToC itm.ada_name
            | false -> ((ToC defModule) + "." + (ToC itm.ada_name))


        override this.Length exp sAcc =
            isvalid_a.ArrayLen exp sAcc

        override this.typeDef (ptd:Map<ProgrammingLanguage, FE_PrimitiveTypeDefinition>) = ptd.[Ada]
        override this.getTypeDefinition (td:Map<ProgrammingLanguage, FE_TypeDefinition>) = td.[Ada]
        override this.getEnmTypeDefintion (td:Map<ProgrammingLanguage, FE_EnumeratedTypeDefinition>) = td.[Ada]
        override this.getStrTypeDefinition (td:Map<ProgrammingLanguage, FE_StringTypeDefinition>) = td.[Ada]
        override this.getChoiceTypeDefinition (td:Map<ProgrammingLanguage, FE_ChoiceTypeDefinition>) = td.[Ada]
        override this.getSequenceTypeDefinition (td:Map<ProgrammingLanguage, FE_SequenceTypeDefinition>) = td.[Ada]
        override this.getSizeableTypeDefinition (td:Map<ProgrammingLanguage, FE_SizeableTypeDefinition>) = td.[Ada]

        override _.getValueAssignmentName (vas: ValueAssignment) = vas.ada_name

        override _.getChildInfoName (ch:Asn1Ast.ChildInfo)  = ch.ada_name
        override _.setChildInfoName (ch:Asn1Ast.ChildInfo) (newValue:string) = {ch with ada_name = newValue}

        override this.getAsn1ChildBackendName (ch:Asn1Child) = ch._ada_name
        override this.getAsn1ChChildBackendName (ch:ChChildInfo) = ch._ada_name
        override this.getAsn1ChildBackendName0 (ch:Asn1AcnAst.Asn1Child) = ch._ada_name
        override this.getAsn1ChChildBackendName0 (ch:Asn1AcnAst.ChChildInfo) = ch._ada_name

        override this.getRtlFiles  (encodings:Asn1Encoding list) (arrsTypeAssignments :string list) =
            let uperRtl = match encodings |> Seq.exists(fun e -> e = UPER || e = ACN) with true -> ["adaasn1rtl.encoding.uper"] | false -> []
            let acnRtl = 
                match arrsTypeAssignments |> Seq.exists(fun s -> s.Contains "adaasn1rtl.encoding.acn") with true -> ["adaasn1rtl.encoding.acn"] | false -> []
            let xerRtl = match encodings |> Seq.exists(fun e -> e = XER) with true -> ["adaasn1rtl.encoding.xer"] | false -> []

            //adaasn1rtl.encoding is included by .uper or .acn or .xer. So, do not include it otherwise you get a warning
            let encRtl = []//match r.args.encodings |> Seq.exists(fun e -> e = UPER || e = ACN || e = XER) with true -> [] | false -> ["adaasn1rtl.encoding"]
            encRtl@uperRtl@acnRtl@xerRtl |> List.distinct

        override this.getSeqChildIsPresent (fpt:FuncParamType) (childName:string) =
            sprintf "%s%sexist.%s = 1" fpt.p (this.getAccess fpt) childName

        override this.getSeqChild (fpt:FuncParamType) (childName:string) (childTypeIsString: bool) (removeDots: bool) =
            let newPath = sprintf "%s.%s" fpt.p childName
            if childTypeIsString then (FIXARRAY newPath) else (VALUE newPath)
        override this.getChChild (fpt:FuncParamType) (childName:string) (childTypeIsString: bool) : FuncParamType =
            let newPath = sprintf "%s.%s" fpt.p childName
            //let newPath = sprintf "%s%su.%s" fpt.p (this.getAccess fpt) childName
            if childTypeIsString then (FIXARRAY newPath) else (VALUE newPath)


        override this.presentWhenName (defOrRef:TypeDefintionOrReference option) (ch:ChChildInfo) : string =
            match defOrRef with
            | Some (ReferenceToExistingDefinition r) when r.programUnit.IsSome -> r.programUnit.Value + "." + ((ToC ch._present_when_name_private) + "_PRESENT")
            | _       -> (ToC ch._present_when_name_private) + "_PRESENT"
        override this.getParamTypeSuffix (t:Asn1AcnAst.Asn1Type) (suf:string) (c:Codec) : CallerScope =
            {CallerScope.modName = t.id.ModName; arg= VALUE ("val" + suf) }

        override this.getLocalVariableDeclaration (lv:LocalVariable) : string  =
            match lv with
            | SequenceOfIndex (i,None)                  -> sprintf "i%d:Integer;" i
            | SequenceOfIndex (i,Some iv)               -> sprintf "i%d:Integer:=%d;" i iv
            | IntegerLocalVariable (name,None)          -> sprintf "%s:Integer;" name
            | IntegerLocalVariable (name,Some iv)       -> sprintf "%s:Integer:=%d;" name iv
            | Asn1SIntLocalVariable (name,None)         -> sprintf "%s:adaasn1rtl.Asn1Int;" name
            | Asn1SIntLocalVariable (name,Some iv)      -> sprintf "%s:adaasn1rtl.Asn1Int:=%d;" name iv
            | Asn1UIntLocalVariable (name,None)         -> sprintf "%s:adaasn1rtl.Asn1UInt;" name
            | Asn1UIntLocalVariable (name,Some iv)      -> sprintf "%s:adaasn1rtl.Asn1UInt:=%d;" name iv
            | FlagLocalVariable (name,None)             -> sprintf "%s:adaasn1rtl.BIT;" name
            | FlagLocalVariable (name,Some iv)          -> sprintf "%s:adaasn1rtl.BIT:=%d;" name iv
            | BooleanLocalVariable (name,None)          -> sprintf "%s:Boolean;" name
            | BooleanLocalVariable (name,Some iv)       -> sprintf "%s:Boolean:=%s;" name (if iv then "True" else "False")
            | AcnInsertedChild(name, vartype, initVal)  -> sprintf "%s:%s;" name vartype
            | GenericLocalVariable lv                   ->
                match lv.initExp with
                | Some initExp  -> sprintf "%s : %s := %s;" lv.name lv.varType  initExp
                | None          -> sprintf "%s : %s;" lv.name lv.varType  

        override this.getLongTypedefName (tdr:TypeDefintionOrReference) : string =
            match tdr with
            | TypeDefinition  td -> td.typedefName
            | ReferenceToExistingDefinition ref ->
                match ref.programUnit with
                | Some pu -> pu + "." + ref.typedefName
                | None    -> ref.typedefName

        override this.decodeEmptySeq p = Some (uper_a.decode_empty_sequence_emptySeq p)
        override this.decode_nullType p = Some (uper_a.decode_nullType p)



        override this.getParamValue  (t:Asn1AcnAst.Asn1Type) (p:FuncParamType)  (c:Codec) =
            p.p

        override this.toHex n = sprintf "16#%x#" n

        override this.bitStringValueToByteArray (v : BitStringValue) = 
            v.ToCharArray() |> Array.map(fun c -> if c = '0' then 0uy else 1uy)

        override this.uper =
            {
                Uper_parts.createLv = (fun name -> IntegerLocalVariable(name,None))
                requires_sBlockIndex  = false
                requires_sBLJ = true
                requires_charIndex = true
                requires_IA5String_i = false
                count_var            = IntegerLocalVariable ("nStringLength", None)
                requires_presenceBit = false
                catd                 = false
                //createBitStringFunction = createBitStringFunction_funcBody_Ada
                seqof_lv              =
                  (fun id minSize maxSize -> 
                    if maxSize >= 65536I && maxSize = minSize then 
                        []
                    else
                        [SequenceOfIndex (id.SeqeuenceOfLevel + 1, None)])
                exprMethodCall        = fun _ _ -> ""
            }
        override this.acn = 
            {
                Acn_parts.null_valIsUnReferenced = false
                checkBitPatternPresentResult = false
                getAcnDepSizeDeterminantLocVars = 
                    fun  sReqBytesForUperEncoding ->
                        [
                            GenericLocalVariable {GenericLocalVariable.name = "tmpBs"; varType = "adaasn1rtl.encoding.BitStream"; arrSize = None; isStatic = false;initExp = Some (sprintf "adaasn1rtl.encoding.BitStream_init(%s)" sReqBytesForUperEncoding)}
                        ]
                createLocalVariableEnum =
                    (fun rtlIntType -> GenericLocalVariable {GenericLocalVariable.name = "intVal"; varType= rtlIntType; arrSize= None; isStatic = false; initExp=None })
                choice_handle_always_absent_child = true
                choice_requires_tmp_decoding = false
          }
        override this.init = 
            {
                Initialize_parts.zeroIA5String_localVars    = fun ii -> [SequenceOfIndex (ii, None)]
                choiceComponentTempInit                     = false
                initMethSuffix                              = fun _ -> ""
            }

        override this.atc =
            {
                Atc_parts.uperPrefix = "UPER_"
                acnPrefix            = "ACN_"
                xerPrefix            = "XER_"
                berPrefix            = "BER_"
            }

        override _.getBoardNames (target:Targets option) =
            match target with
            | None              -> ["x86"]  //default board
            | Some X86          -> ["x86"] 
            | Some Stm32        -> ["stm32"] 
            | Some Msp430       -> ["msp430"] 
            | Some AllBoards    -> ["x86";"stm32";"msp430"] 

        override this.getBoardDirs (target:Targets option) =
            let boardsDirName = match target with None -> "" | Some _ -> "boards"
            this.getBoardNames target |> List.map(fun s -> Path.Combine(boardsDirName , s))


        override this.CreateMakeFile (r:AstRoot)  (di:DirInfo) =
            let boardNames = this.getBoardNames r.args.target
            let writeBoard boardName = 
                let mods = aux_a.rtlModuleName()::(r.programUnits |> List.map(fun pu -> pu.name.ToLower() ))
                let content = aux_a.PrintMakeFile boardName (sprintf "asn1_%s.gpr" boardName) mods
                let fileName = if boardNames.Length = 1 || boardName = "x86" then "Makefile" else ("Makefile." + boardName)
                let outFileName = Path.Combine(di.rootDir, fileName)
                File.WriteAllText(outFileName, content.Replace("\r",""))
            this.getBoardNames r.args.target |> List.iter writeBoard

        override this.getDirInfo (target:Targets option) rootDir =
            match target with
            | None -> {rootDir = rootDir; srcDir=rootDir;asn1rtlDir=rootDir;boardsDir=rootDir}
            | Some _   -> 
                {
                    rootDir = rootDir; 
                    srcDir=Path.Combine(rootDir, "src");
                    asn1rtlDir=Path.Combine(rootDir, "asn1rtl");
                    boardsDir=Path.Combine(rootDir, "boards")
                }

        override this.getTopLevelDirs (target:Targets option) =
            match target with
            | None -> []
            | Some _   -> ["src"; "asn1rtl"; "boards"]



        override _.CreateAuxFiles (r:AstRoot)  (di:DirInfo) (arrsSrcTstFiles : string list, arrsHdrTstFiles:string list) =
            ()

