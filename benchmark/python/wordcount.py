import sys
import time
from collections import defaultdict


def count_words(filename):
    word_counts = defaultdict(int)

    with open(filename, "r") as f:
        for line in f:
            words = line.strip().split()
            for word in words:
                word_counts[word.lower()] += 1

    return word_counts


def get_top_words(word_counts, n=10):
    return sorted(word_counts.items(), key=lambda x: x[1], reverse=True)[:n]


def main():
    if len(sys.argv) < 2:
        print("Usage: python wordcount.py <filename>")
        sys.exit(1)

    filename = sys.argv[1]

    print(f"Python: Counting words in {filename}...")
    start_time = time.time()

    word_counts = count_words(filename)
    top_words = get_top_words(word_counts)

    elapsed = time.time() - start_time

    print("Top 10 most common words:")
    for i, (word, count) in enumerate(top_words, 1):
        print(f"{i:2d}. {word:15s} {count:10d}")

    print(f"Total unique words: {len(word_counts)}")
    print(f"Execution time: {elapsed:.3f} seconds")


if __name__ == "__main__":
    main()
