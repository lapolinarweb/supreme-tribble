
# Formatting tests:

"" # lgtm
"" # lgtm[py/line-too-long]
"" # lgtm[py/line-too-long, py/non-callable-called]
"" # lgtm[@tag:security]
"" # lgtm[@tag:security,py/line-too-long]
"" # lgtm[@expires:2017-06-11]
"" # lgtm[py/non-callable-called] because I know better than lgtm
"" # lgtm: blah blah
"" # lgtm blah blah #falsepositive
"" # lgtm blah blah -- falsepositive
"" #lgtm  [py/non-callable-called]
"" # lgtm[]
"" # lgtmfoo
"" #lgtm
"" #    lgtm
"" # lgtm    [py/line-too-long]
"" # lgtm lgtm


#lgtm -- Ignore this -- No line or scope.

#On real code:

def foo(): #lgtm [func]
    # lgtm -- Blank line (ignore for now, maybe scope wide in future).
    "docstring" # lgtm on docstring
    return {   #lgtm [py/duplicate-key-in-dict]
        "a": 1,
        "a": 2
    }

class C: # lgtm class
    def meth(self): # lgtm method
        pass

"" #noqa
"" # noqa

"The following should be ignored"
"" # flake8: noqa
"" # noqa: F401
"" # noqa -- Some extra detail.
"" #Ignore

#Suppression for multiple tools
#LGTM-1929
class frozenbidict(BidictBase):  # noqa: E501; (line too long) pylint: disable=invalid-name; lgtm [py/missing-equals]
    pass
"" # noqa: E501; (line too long) pylint: disable=invalid-name; lgtm
"" # random nonsense lgtm [py/missing-equals] and then some more commentary...


# Case insensitive comments

"" # LGTM
"" # LGTM[py/line-too-long]

#Avoid some erroneous matches
"" # foolgtm[py/missing-equals]
"" # foolgtm

"" # lgtm[py/line-too-long] and lgtm[py/non-callable-called]
"" # lgtm[py/line-too-long]; lgtm
