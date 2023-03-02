import os
import sys

executable_path = os.path.dirname(os.path.realpath(sys.argv[0]))

result_fold = os.path.exists(os.getcwd() + "\\results\\")
