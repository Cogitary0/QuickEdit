import os
import zipfile
import json
import pathlib
import time


def main() -> None:
    
    with zipfile.ZipFile(f'{NAME_FILE}.zip', 'w') as release_file:

        for root, dirs, files in os.walk(PATH):
            
            for file in files:
                if file.endswith(('.py', '.zip')) or \
                    root.split(PATH)[1] == EXCEPTION[0] or \
                        root.split(PATH)[1] == EXCEPTION[1] or \
                            root.split(PATH)[1] == EXCEPTION[2]:
                                
                    continue  
                
                if linear_search(root.split("/")[-1].split("\\"), ".git") != -1: 
                    break

                rel_path = os.path.relpath(os.path.join(root, file), PATH)

                release_file.write(os.path.join(root, file), f"quickedit/{rel_path}")
                

def package_read() -> tuple[str, ...]:
    
    package_path = pathlib.Path(PATH + "/package.json")
    
    with package_path.open("r") as package_file:
        __file = json.load(package_file)
        
    return (__file)


def linear_search(A, key) -> int:
    
        for i in range(len(A)):
            
            if A[i] == key:
                
                return i
            
        return -1


            
if __name__  == "__main__":
    
    PATH = os.path.dirname(os.path.dirname(__file__))
    VERSION = f"v{package_read()['version']}"
    NAME_FILE = f'quickedit_{VERSION}' 
    EXCEPTION = ['\\.dev\\math', '\\.vscode', '\\.autobuild', '\\.git']
    
    print(f"[{PATH}]")
    print(f"[Version CP: {VERSION}]")
    print(f"[Name CP: {NAME_FILE}]")
    
    main()
    
    print("[end build]")
    time.sleep(0.5)
    exit()
