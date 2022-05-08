import time

class Solution:
    """
    class Solution:
        Implements methods for printing node paths and generating timestamps

    - param Node node: reference to the node for which to print path
    - param int nrInstances: count of all instances of <class Node>
    - param int maxInstances: max count of instances of <class Node> in memory at any given time
    """

    startTime = None

    def __init__(self, node, nrInstances, maxInstances):
        self.node = node
        self.time = round(time.time() - __class__.startTime, 3)
        self.nrInstances = nrInstances
        self.maxInstances = maxInstances

    def __repr__(self):
        """
        function __repr__:
            String representation of <class Solution> objects
            
        :template:
        SOLUTION:
            - length: 0
            - cost: 0
            - time: 0.0 sec.
            - max instances: 0
            - all instances: 0
            - <Node object>
        
        :return str: string representation of <class Solution> object
        """

        rep = "SOLUTION:\n"
        rep += f"   - length: {self.node.depth}\n"
        rep += f"   - cost: {self.node.cost}\n"
        rep += f"   - time: {self.time} sec.\n"
        rep += f"   - max instances: {self.maxInstances}\n"
        rep += f"   - all instances: {self.nrInstances}\n\n"
        rep += self.node.printPath()
        rep += "-------------------------------------------\n\n"
        return rep