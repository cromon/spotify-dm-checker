# Spotify-DM opt-in sorter

This is a simple Ruby and DuckDB script that sorts your Spotify DM opt-ins (from FUGA) given a defined minimum up-lift.

Default uplift is 50(%)

Edit the filenames and if desired the uplift and the run this script with the CSVs and the ruby script in the same directory - 
it's as simples as: ```ruby spotify-dm.rb```

After you've run this you a CSV without Tracks that have had under the minimum uplift %age will be saved to the same folder.

It includes any new Tracks that have been made eligible in for the next period.

## Requirements

1. DuckDB v0.9.2 - https://duckdb.org/
2. Ruby v3.2.2 - https://www.ruby-lang.org/en/
3. Ruby DuckDB Gem v0.9.1.2 - https://github.com/suketa/ruby-duckdb
