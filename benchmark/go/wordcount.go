package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strings"
	"time"
)

type wordCount struct {
	word  string
	count int
}

func countWords(filename string) (map[string]int, error) {
	wordCounts := make(map[string]int)

	file, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		words := strings.Fields(line)
		for _, word := range words {
			wordCounts[strings.ToLower(word)]++
		}
	}

	if err := scanner.Err(); err != nil {
		return nil, err
	}

	return wordCounts, nil
}

func getTopWords(wordCounts map[string]int, n int) []wordCount {
	words := make([]wordCount, 0, len(wordCounts))
	for word, count := range wordCounts {
		words = append(words, wordCount{word, count})
	}

	sort.Slice(words, func(i, j int) bool {
		return words[i].count > words[j].count
	})

	if len(words) > n {
		words = words[:n]
	}

	return words
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: go run wordcount.go <filename>")
		os.Exit(1)
	}

	filename := os.Args[1]

	fmt.Printf("Go: Counting words in %s...\n", filename)
	startTime := time.Now()

	wordCounts, err := countWords(filename)
	if err != nil {
		fmt.Printf("Error: %v\n", err)
		os.Exit(1)
	}

	topWords := getTopWords(wordCounts, 10)
	elapsed := time.Since(startTime)

	fmt.Println("\nTop 10 most common words:")
	for i, wc := range topWords {
		fmt.Printf("%2d. %-15s %10d\n", i+1, wc.word, wc.count)
	}

	fmt.Printf("\nTotal unique words: %d\n", len(wordCounts))
	fmt.Printf("Execution time: %.3f seconds\n", elapsed.Seconds())
}
