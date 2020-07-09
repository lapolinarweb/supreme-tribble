
#This is prone to strange side effects and race conditions.
class MutatingDescriptor(object):
    
    def __init__(self, func):
        self.my_func = func
        
    def __get__(self, obj, obj_type):
        #Modified state is visible to all instances of C that might call "show".
        self.my_obj = obj
        return self
        
    def __call__(self, *args):
        return self.my_func(self.my_obj, *args)