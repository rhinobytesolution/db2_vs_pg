use std::time::{Duration, Instant};

fn main() {
    // Get the start time
    let start = Instant::now();
    let mut count = 0;

    // Loop until one second has passed
    while start.elapsed() < Duration::from_secs(1) {
        // Call your function
        let _ = db2wrapper::db2::select();
        // Increment the count
        count += 1;
    }

    // Print the number of times the function was called in one second
    println!(
        "db2wrapper::db2::select() was called {} times in one second.",
        count
    );
}
