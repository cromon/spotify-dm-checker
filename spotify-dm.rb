require 'csv'
require 'duckdb'

db = DuckDB::Database.open
con = db.connect

# SET FILE NAMES
mid_campaign_filename = '2025-05_Cromon Ltd_2335678080_SpotifyDM__MidCampaign_PerformanceReport.csv' # Add The filename for your Mid-period campaign stats
eligible_music_filename = '2025-05-15_Cromon Ltd_2335678080_spotify_discovery_mode_eligible.csv' # Add The filename for your Proposed eligible music
minimum_percentage_streams_lift = 50 # Set the minimum uplift you want to allow to opt in

# Create tables
con.query("CREATE TABLE mid_campaign AS SELECT * FROM '#{mid_campaign_filename.to_s}'")
con.query("CREATE TABLE eligible AS SELECT * FROM '#{eligible_music_filename.to_s}'")

# select isrcs and lift% from campaign
camp_result = con.query('SELECT isrc_code, "DM contexts % lift" FROM mid_campaign')

# get a list of ISRCs that should not be opted in for the next term
isrcs_for_removal = camp_result.to_a.select{|row| row[1].to_s.gsub(",","").gsub("%","").to_i < minimum_percentage_streams_lift}.map{|row| row[0]}
in_clause = isrcs_for_removal.map{|isrc| "'#{isrc}'"}.join(', ')

# duplicate eligible table
con.query("CREATE TABLE submit_eligible AS SELECT * FROM eligible")

# remove records that are ineligible
con.query("DELETE FROM submit_eligible WHERE isrc_code IN (#{in_clause})")

# save off a CSV of those results
con.query("COPY submit_eligible to 'submit_eligible-#{Date.today.year.to_s}-#{Date.today.month.to_s}.csv'")
