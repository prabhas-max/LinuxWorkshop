#!/bin/bash

# Read URLs from url.txt
while IFS= read -r url; do
    # Get the page title from the URL (assuming the URL is a Wikipedia page)
    title=$(echo "$url" | awk -F/ '{print $(NF)}' | sed 's/_/ /g')
    
    # Fetch the HTML content from the URL
    html_content=$(curl -s "$url")

    # Extract the first paragraph using awk
    first_paragraph=$(echo "$html_content" | awk -v RS="<p>" -v ORS="" 'NR==2 {gsub("</?[^>]+>", "", $0); print $0}')

    # Save the first paragraph to a file named <TITLE>.txt
    echo "$first_paragraph" > "${title}.txt"
done < url.txt
