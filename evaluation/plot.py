import pandas as pd
import matplotlib.pyplot as plt
import argparse
import os
import numpy as np

def main(file_path, prefix):
    # Leggi i dati dal file CSV
    df = pd.read_csv(file_path)

    # Prendi i nomi delle colonne per le etichette
    x_label = df.columns[0]
    y_label = df.columns[1]




    # Costruisci i nomi delle colonne per la deviazione standard
    std_dev_col = f'{prefix}_StdDev'

    # Verifica che la colonna di deviazione standard esista
    if std_dev_col not in df.columns:
        print(f'Error: The column {std_dev_col} does not exist in the CSV file.')
        return

    # Ottieni la deviazione standard per ciascun punto
    std_dev = df[std_dev_col]

    # Crea il grafico
    plt.figure(figsize=(10, 6))
        # Impostazione dei limiti degli assi per allargare la scala
    #plt.xlim(-0.5, 6.5)  # Allarga la scala dell'asse x
    plt.ylim(-0.5, 200.5)  # Allarga la scala dell'asse y
    plt.plot(df[x_label], df[y_label], marker='o', linestyle='-', color='b', label=y_label)

    # Aggiunge bande di deviazione standard
    upper_bound = df[y_label] + std_dev
    lower_bound = df[y_label] - std_dev
    plt.fill_between(df[x_label], upper_bound, lower_bound, color='b', alpha=0.1, label='Deviazione standard')

    # Aggiunge titolo e etichette
    plt.title(f'{y_label} per {x_label}')
    plt.xlabel(x_label)
    plt.ylabel(y_label)

    # Aggiunge una griglia
    plt.grid(True)

    # Aggiunge una legenda
    plt.legend()

    # Ottieni la cartella del file CSV
    output_folder = os.path.dirname(file_path)

    # Salva il grafico come immagine nella stessa cartella del file CSV
    output_filename = os.path.splitext(os.path.basename(file_path))[0] + '_plot.png'
    output_filepath = os.path.join(output_folder, output_filename)
    plt.savefig(output_filepath)

    # Mostra il grafico
    plt.show()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Plot CPU Usage from CSV file.')
    parser.add_argument('file_path', type=str, help='Path to the CSV file containing CPU usage data.')
    parser.add_argument('prefix', type=str, help='Prefix to identify columns for standard deviation calculation.')

    args = parser.parse_args()
    main(args.file_path, args.prefix)
