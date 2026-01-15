import sys
import time


def count_words(filename: str) -> dict[str, int]:
    word_counts = dict[str, int]()

    with open(filename, "r") as f:
        for line in f:
            words = line.strip().split()
            for word in words:
                w = word.lower()
                word_counts[w] = word_counts.get(w, 0) + 1

    return word_counts


def get_top_words(word_counts: dict[str, int], n: int = 10) -> list[tuple[str, int]]:
    items = list(word_counts.items())
    items.sort(key=lambda x: x[1], reverse=True)
    return items[:n]


def main():
    if len(sys.argv) < 2:
        print("Usage: codon run wordcount.py <filename>")
        sys.exit(1)

    filename = sys.argv[1]

    print(f"Codon: Counting words in {filename}...")
    start_time = time.time()

    word_counts = count_words(filename)
    top_words = get_top_words(word_counts)

    elapsed = time.time() - start_time

    print("\nTop 10 most common words:")
    for i, (word, count) in enumerate(top_words, 1):
        print(f"{i:2d}. {word:15s} {count:10d}")

    print("\nTotal unique words: {len(word_counts)}")
    print(f"Execution time: {elapsed:.3f} seconds")


main()
