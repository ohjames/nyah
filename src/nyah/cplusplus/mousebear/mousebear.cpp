#include <chilon/conf/cmd/command_line.hpp>

#include <iostream>

#define MOUSEBEAR_VERSION "1000 (just don't get in a car, and stay away from my family)"

namespace nyah { namespace mousebear {

namespace cmd_line = chilon::conf::cmd;

inline int main(int argc, char *argv[]) {
    int nPositionals;
    bool verbose = false;
    {
        using chilon::conf::value;
        using cmd_line::options_description;

        options_description options;
        options.add_options()
            .help("mousebear "   MOUSEBEAR_VERSION "\nusage: mousebear [arguments] [grammar files to process]")
            ("v,verbose",        verbose, "increase verbosity")
            ;

        try {
            nPositionals = cmd_line::parser(argc, argv, options)(std::cerr).n_positionals();
        }
        catch (cmd_line::invalid_arguments& ) {
            return 1;
        }
        catch (cmd_line::bad_value& e) {
            std::cerr << "bad value reading command line options\n";
            std::cout << options << std::endl;
            return 1;
        }
        catch (cmd_line::expected_argument& e) {
            std::cerr << "expected command line argument\n";
            std::cout << options << std::endl;
            return 1;
        }
    }
    return 0;
}

} }

int main(int argc, char *argv[]) {
    return nyah::mousebear::main(argc, argv);
}
