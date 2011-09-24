module mousedeer.test;

import teg.all;
import beard.io;
import std.typecons;
import std.stdio;

auto nFailures = 0u;

void parseTest(P, S)(string name, S s) {
    s.reset();
    auto parser = new P();
    write(name, ": ");
    if (parser.parse(s))
        println(parser.value_);
    else {
        println("failed to store");
        ++nFailures;
    }
}

void testParser() {
    alias many!(char_from!"\n\t ") whitespace;

    auto s = new stream!whitespace("var friend = baby");

    alias char_not_from!"\n\t " non_whitespace;
    alias many_plus!non_whitespace word1;
    alias sequence!(char_!"var", word1) vardef1;

    parseTest!(vardef1)("sequence", s);

    parseTest!(
        sequence!(char_!"var", word1, char_!"=", word1))("sequence2", s);

    s = "var v1\nvar v2 ";
    parseTest!(many!vardef1)("many list", s);

    alias lexeme!(char_range!"azAZ", many!(char_range!"azAZ09")) identifier1;

    alias sequence!(char_!"var", identifier1) var1;
    parseTest!(many_plus!var1)("lexeme", s);

    parseTest!(store_range!(var1))("store_range", s);
    // parseTest!(many_plus!identifier1)("lexeme", s);
}

int main() {
    testParser();
    return nFailures;
}