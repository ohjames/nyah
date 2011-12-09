module mousedeer.parser.nyah;

import teg.all;

//////////////////////////////////////////////////////////////////////////////
// global
alias CharFrom!"\n\t " WhitespaceChars;
alias Skip!(Many!(CharFrom!"\t ")) NonBreakingSpace;
alias ManyPlus!WhitespaceChars Whitespace;

class Expression { mixin makeNode!TupleOp; }
alias Node!Expression ExpressionRef;

alias Lexeme!(
    Choice!(Char!"_",
            CharRange!"azAZ"),
    Many!(Choice!(CharRange!"azAZ09", Char!"_")))     Identifier;

//////////////////////////////////////////////////////////////////////////////
// numbers
alias ManyPlus!(CharRange!"09") _Integer;
struct Integer { mixin makeNode!_Integer; }
struct RealNumber { mixin makeNode!(_Integer, Char!".", _Integer); }
alias Choice!(RealNumber, Integer) Number;

//////////////////////////////////////////////////////////////////////////////
// function
alias Choice!(
    Char!"def!",
    Char!"def",
    Sequence!(Store!(Char!"override"), Char!"def")) FunctionPrefix;

alias Identifier ArgumentDefinition; // todo

alias Sequence!(
    Char!"(",
    Joined!(Char!",", ArgumentDefinition),
    Char!")")                               ArgumentsDefinition;

alias Choice!(
    Sequence!(
        Char!"{",
        Many!ExpressionRef,
        Char!"}"),
    ExpressionRef)     CodeBlock;

class Function {
    mixin makeNode!(
        FunctionPrefix,
        Identifier,
        Optional!ArgumentsDefinition,
        CodeBlock);
}

template BinOp(J, T...) {
    alias TreeJoinedTight!(
        Lexeme!(NonBreakingSpace, J, Skip!(Many!WhitespaceChars)),
        T) BinOp;
}

//////////////////////////////////////////////////////////////////////////////
// expressions
class TupleOp {
    mixin makeNode!(BinOp!(Char!",", AssigningOp));
}

alias Choice!(
    Char!"=",
    Char!"+=",
    Char!"-=",
    Char!"*=",
    Char!"/=",
    Char!"%=",
    Char!"<<=",
    Char!">>=",
    Char!"&=",
    Char!"^=",
    Char!"|=") AssigningOps;

class AssigningOp { mixin makeNode!(BinOp!(AssigningOps, OrOp)); }

class OrOp { mixin makeNode!(BinOp!(Char!"||", AndOp)); }

class AndOp { mixin makeNode!(BinOp!(Char!"&&", BitwiseOrOp)); }

class BitwiseOrOp { mixin makeNode!(BinOp!(Char!"|", BitwiseXOrOp)); }

class BitwiseXOrOp { mixin makeNode!(BinOp!(Char!"^", BitwiseAndOp)); }

class BitwiseAndOp { mixin makeNode!(BinOp!(Char!"&", EquivalenceOp)); }

class EquivalenceOp {
    mixin makeNode!(
        BinOp!(Choice!(Char!"==", Char!"!="), InequalityOp));
}

class InequalityOp {
    mixin makeNode!(BinOp!(
        Choice!(Char!"<=", Char!">=", Char!"<", Char!">"), ShiftOp));
}

class ShiftOp {
    mixin makeNode!(BinOp!(Choice!(Char!"<<", Char!">>"), AdditionOp));
}

class AdditionOp { mixin makeNode!(BinOp!(CharFrom!"+-", ScalingOp)); }

class ScalingOp { mixin makeNode!(BinOp!(CharFrom!"*/%", PointerToMemberOp)); }

class PointerToMemberOp {
    mixin makeNode!(BinOp!(Choice!(Char!".*", Char!"->*"), FunctionCall));
}

class FunctionCall {
    mixin makeNode!(TreeJoinedTight!(NonBreakingSpace, PrefixOp));
}

// meow todo
// class PrefixOp {
//     mixin makeNode!(
//         BinOp!(Choice!(
//             Char!".*", Char!"->*"),
//             PrefixOp));
// }
alias Term PrefixOp;

alias Choice!(
    Identifier,
    Number,
    Sequence!(Char!"(", ExpressionRef, Char!")")) Term;

//////////////////////////////////////////////////////////////////////////////
// top level
alias Function TopLevel; // todo

alias Many!TopLevel Grammar;