use std::env;
use std::fs::File;
use std::io::Write;

fn main() {
    // Get the arguments passed to the program
    let args: Vec<String> = env::args().collect();

    // Check if an argument was provided
    if args.len() < 2 {
        eprintln!("Error: No argument provided. Usage: <program> <argument>");
        std::process::exit(1);
    }

    // Get the first argument after the program name
    let argument = &args[1];

    // Print the argument to stdout
    println!("{}", argument);

    // Write the argument to "out.txt"
    let mut file = match File::create("out.txt") {
        Ok(file) => file,
        Err(err) => {
            eprintln!("Error creating file: {}", err);
            std::process::exit(1);
        }
    };

    if let Err(err) = writeln!(file, "{}", argument) {
        eprintln!("Error writing to file: {}", err);
        std::process::exit(1);
    }
}
