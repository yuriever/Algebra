(* ::Package:: *)

(* ::Section:: *)
(*Begin*)


BeginPackage["Yurie`Algebra`Tensor`"];


Needs["Yurie`Algebra`"];

Needs["Yurie`Algebra`Variable`"];


(* ::Section:: *)
(*Public*)


tensor::usage =
    "tensor product.";

comultiply::usage =
    "comultiplication of coalgebra.";

counit::usage =
    "counit of coalgebra.";

antipode::usage =
    "antipode of Hopf algebra.";


tensorCompose::usage =
    "composite the tensors over multiplication according to tensor rank.";

tensorPermute::usage =
    "permute the arguments of the tensor.";


(* ::Text:: *)
(*This is used by algebraInternal["Tensor"] in Internal.wl.*)


$composition;


(* ::Subsection:: *)
(*Begin*)


Begin["`Private`"];


(* ::Subsection:: *)
(*tensorCompose*)


(* ::Subsubsection:: *)
(*Main*)


tensorCompose[tensor[x__],tensor[y__]] :=
    compose[{x},{y}];

tensorCompose[x_,y_] :=
    x**y;

tensorCompose[x_tensor] :=
    x;

tensorCompose[x_NonCommutativeMultiply] :=
    Fold[tensorCompose,x];

tensorCompose[k_?scalarQ*x_.] :=
    k*tensorCompose[x];


(* ::Subsubsection:: *)
(*Helper*)


head::usage =
    "head placeholder used by tensorCompose.";

slot::usage =
    "slot placeholder used by tensorCompose.";


compose[opList1_,opList2_] :=
    head[addSlot[opList1],addSlot[opList2]]//Thread//
    	Split[#,MemberQ[#2,slot]&]&//
	    	Map[Thread[#,head]&]//
				ReplaceAll[slot->Nothing]//
					ReplaceAll[{z_}:>z]//
						ReplaceAll[{head->NonCommutativeMultiply,List->tensor}];


addSlot[opList_] :=
    Flatten@Riffle[
        opList,
        opList//Map[tensorank@#-1&]//Map[ConstantArray[slot,#]&]
    ];


(* ::Subsection:: *)
(*tensorPermute*)


tensorPermute[args___][x_+y_] :=
    tensorPermute[args][x]+tensorPermute[args][y];

tensorPermute[args___][k_?scalarQ*x_tensor] :=
    k*tensorPermute[args][x];

tensorPermute[][x_tensor] :=
    x;

tensorPermute[positions__Integer][x_tensor] :=
    Permute[x,Cycles@{{positions}}];

tensorPermute[positionList:{__Integer}..][x_tensor] :=
    Permute[x,Cycles@{positionList}];

tensorPermute[cycle_Cycles][x_tensor] :=
    Permute[x,cycle];


(* ::Subsection:: *)
(*$composition*)


$composition =
    tensor[x__]**tensor[y__]:>
        compose[{x},{y}];


(* ::Subsection::Closed:: *)
(*End*)


End[];


(* ::Section:: *)
(*End*)


EndPackage[];
