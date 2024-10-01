import os

def delete_cm_files(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.cm'):
                file_path = os.path.join(root, file)
                try:
                    os.remove(file_path)
                    print(f'Удален: {file_path}')
                except Exception as e:
                    print(f'Не удалось удалить {file_path}: {e}')

if __name__ == '__main__':
    target_directory = input('Введите путь к директории: ')
    delete_cm_files(target_directory)

