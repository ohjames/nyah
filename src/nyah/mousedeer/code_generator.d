module mousedeer.code_generator;

import bustin.core;
import mousedeer.parser.nyah : Ast;
import mousedeer.project : Project;

// Generates one bytecode file per object module. See documentation for
// ObjectModule.
class CodeGenerator {
  private Project project_;

  this(Project project) { project_ = project; }

  void opCall(Ast ast) {
  }

  void createBytecodeFiles() {
    project_.buildOverloadTables;
    // TODO:
  }

  void linkBytecodeFiles() {
  }
}
// vim:ts=2 sw=2:
