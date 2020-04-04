# ECE 3310 Group 7 Report 2 Question 3-5 in Python 
# Author: Choi Tim Antony Yung

class LinkedListNode:
    def __init__(self,data,next=None):
        self._data = data
        self._next = next

    @property 
    def data(self):
        return self._data

    @data.setter
    def data(self,data):
        self._data = data

    @property
    def next(self):
        return self._next

    @next.setter
    def next(self,next):
        self._next = next

    def __str__(self):
        return self._data.__str__()

class DoublyLinkedListNode(LinkedListNode):
    def __init__(self,data,next=None,prev=None):
        super().__init__(data,next)
        self._prev = prev
    
    @property
    def prev(self):
        return self._prev

    @prev.setter
    def prev(self, prev):
        self._prev = prev

class LinkedList:
    _classname = 'LinkedList'
    def __init__(self):
        self._firstNode = None
        self._lastNode = None

    @property
    def classname(self):
        return self._classname
        
    @property
    def firstNode(self):
        return self._firstNode
    
    @firstNode.setter
    def firstNode(self, firstNode):
        self._firstNode = firstNode

    @property
    def lastNode(self):
        return self._lastNode
    
    @lastNode.setter
    def lastNode(self, lastNode):
        self._lastNode = lastNode

    def isEmpty(self):
        return self._firstNode == None
    
    def count(self):
        if self.isEmpty():
            return 0
        counter = 1
        current = self._firstNode
        while current is not self._lastNode:
            nextNode = current.next
            current = nextNode
            counter = counter + 1
        return counter

    def search(self,key):
        if self.isEmpty():
            return None
        counter = 0
        current = self._firstNode
        while current is not self._lastNode and current.data != key:
            nextNode = current.next
            current = nextNode
            counter = counter + 1
        if current.data == key: 
            return counter
        return None

    def __str__(self):
        retstr = self._classname + ': ['
        if self.isEmpty():
            retstr = ' ' + retstr + ' ]'
            return retstr
        current = self._firstNode
        while current is not self._lastNode:
            retstr = retstr + ' '+ str(current) +' ,'
            nextNode = current.next
            current = nextNode
        retstr = retstr + ' ' + str(current) + ' ]'
        return retstr

    def InsertAtFront(self,insertItem):
        if self.isEmpty():
            self._firstNode = LinkedListNode(insertItem)
            self._lastNode = self._firstNode
        else:
            newNode = LinkedListNode(insertItem,self._firstNode)
            self._firstNode = newNode

    def InsertAtBack(self,insertItem):
        if self.isEmpty():
            self._firstNode = LinkedListNode(insertItem)
            self._lastNode = self._firstNode
        else:
            newNode = LinkedListNode(insertItem)
            self._lastNode.next = newNode
            self._lastNode = newNode
            
    def RemoveFromFront(self):
        if self.isEmpty():
            raise IndexError('Attempting to remove from an empty list.')

        removeItem = self._firstNode.data

        if self._firstNode is self._lastNode:
            self._firstNode = None
            self._lastNode = None
        else:
            newfirst = self._firstNode.next
            self._firstNode = newfirst

        return removeItem

    def RemoveFromBack(self):
        if self.isEmpty():
            raise IndexError('Attempting to remove from an empty list.')
            
        removeItem = self._lastNode.data

        if self._firstNode is self._lastNode:
            self._firstNode = None
            self._lastNode = None
        else:
            current = self._firstNode
            while current.next is not self._lastNode:
                nextNode = current.next
                current = nextNode
            
            self._lastNode = current
            current.next = None
        return removeItem

    def InsertInTheMiddle(self, insertItem, idx):
        if idx <= 0 or self.isEmpty():
            self.InsertAtFront(insertItem)
            return
        else:
            current = self._firstNode
            while idx > 1:
                if current.next == None:
                    raise IndexError('Attempting to insert at index out of bound')
                nextNode = current.next
                current = nextNode
                idx = idx - 1
            # variable current is now the one before the one at idx
            if current is self._lastNode:
                self.InsertAtBack(insertItem)
                return
            else:
                newNode = LinkedListNode(insertItem,current.next)
                current.next = newNode
        return
    
    def removeInTheMiddle(self, idx):
        if self.isEmpty():
            raise IndexError('Attempting to remove from empty list')
        if idx <= 0:
            self.RemoveFromFront()
            return
        else:
            current = self._firstNode
            while idx > 1:
                if current.next == None:
                    raise IndexError('Attempting to insert at index out of bound')
                nextNode = current.next
                current = nextNode
                idx = idx - 1
            # variable current is now the one before the one at idx
            if current.next is self._lastNode:
                self.RemoveFromBack()
                return
            else:
                current.next = current.next.next
        return

class CircularLinkedList(LinkedList):
    _classname = "CircularLinkedList"
    
    def __init__(self):
        super().__init__()
    
    def isEmpty(self):
        return self._firstNode == None
    
    def InsertAtFront(self,insertItem):
        if self.isEmpty():
            self._firstNode = LinkedListNode(insertItem)
            self._firstNode.next = self._firstNode # only one, next to itself
            self._lastNode = self._firstNode
        else:
            newNode = LinkedListNode(insertItem,self._firstNode)
            self._firstNode = newNode
            self._lastNode.next = newNode

    def InsertAtBack(self,insertItem):
        if self.isEmpty():
            self._firstNode = LinkedListNode(insertItem)
            self._firstNode.next = self._firstNode # only one, next to itself
            self._lastNode = self._firstNode
        else:
            newNode = LinkedListNode(insertItem,self._firstNode) # new lastNode's next is firstNode
            self._lastNode.next = newNode
            self._lastNode = newNode
            
    def RemoveFromFront(self):
        if self.isEmpty():
            raise IndexError('Attempting to remove from an empty list.')

        removeItem = self._firstNode.data

        if self._firstNode is self._lastNode:
            self._firstNode = None
            self._lastNode = None
        else:
            newfirst = self._firstNode.next
            self._firstNode = newfirst
            self._lastNode.next = newfirst

        return removeItem

    def RemoveFromBack(self):
        if self.isEmpty():
            raise IndexError('Attempting to remove from an empty list.')
            
        removeItem = self._lastNode.data

        if self._firstNode is self._lastNode:
            self._firstNode = None
            self._lastNode = None
        else:
            current = self._firstNode
            while current.next is not self._lastNode:
                nextNode = current.next
                current = nextNode
            
            self._lastNode = current
            current.next = self._firstNode
        return removeItem

    def InsertInTheMiddle(self, insertItem, idx):
        if idx <= 0 or self.isEmpty():
            self.InsertAtFront(insertItem)
            return
        else:
            current = self._firstNode
            while idx > 1:
                if current.next == None:
                    raise IndexError('Attempting to insert at index out of bound')
                nextNode = current.next
                current = nextNode
                idx = idx - 1
            # variable current is now the one before the one at idx
            if current is self._lastNode:
                self.InsertAtBack(insertItem)
                return
            else:
                newNode = LinkedListNode(insertItem,current.next)
                current.next = newNode
        return

class DoublyLinkedList:
    _classname = 'DoublyLinkedList'
    def __init__(self):
        self._firstNode = None
        self._lastNode = None

    @property
    def classname(self):
        return self._classname

    @property
    def firstNode(self):
        return self._firstNode
    
    @firstNode.setter
    def firstNode(self, firstNode):
        self._firstNode = firstNode

    @property
    def lastNode(self):
        return self._lastNode
    
    @lastNode.setter
    def lastNode(self, lastNode):
        self._lastNode = lastNode

    def isEmpty(self):
        return self._firstNode == None
    
    def count(self):
        if self.isEmpty():
            return 0
        counter = 1
        current = self._firstNode
        while current is not self._lastNode:
            nextNode = current.next
            current = nextNode
            counter = counter + 1
        return counter

    def search(self,key):
        if self.isEmpty():
            return None
        counter = 0
        current = self._firstNode
        while current is not self._lastNode and current.data != key:
            nextNode = current.next
            current = nextNode
            counter = counter + 1
        if current.data == key: 
            return counter
        return None
    
    def __str__(self):
        retstr = self._classname + ': ['
        if self.isEmpty():
            retstr = ' ' + retstr + ' ]'
            return retstr
        current = self._firstNode
        while current is not self._lastNode:
            retstr = retstr + ' '+ str(current) +' ,'
            nextNode = current.next
            current = nextNode
        retstr = retstr + ' ' + str(current) + ' ]'
        return retstr
    
    def InsertAtFront(self,insertItem):
        if self.isEmpty():
            self._firstNode = DoublyLinkedListNode(insertItem)
            self._lastNode = self._firstNode
        else:
            newNode = DoublyLinkedListNode(insertItem,self._firstNode,None)
            self._firstNode.prev = newNode
            self._firstNode = newNode

    def InsertAtBack(self,insertItem):
        if self.isEmpty():
            self._firstNode = DoublyLinkedListNode(insertItem)
            self._lastNode = self._firstNode
        else:
            newNode = DoublyLinkedListNode(insertItem,None,self._lastNode) # Next is None, Prev is lastNode
            self._lastNode.next = newNode
            self._lastNode = newNode
            
    def RemoveFromFront(self):
        if self.isEmpty():
            raise IndexError('Attempting to remove from an empty list.')

        removeItem = self._firstNode.data

        if self._firstNode is self._lastNode:
            self._firstNode = None
            self._lastNode = None
        else:
            newfirst = self._firstNode.next
            self._firstNode = newfirst
            self._firstNode.prev = None

        return removeItem

    def RemoveFromBack(self):
        if self.isEmpty():
            raise IndexError('Attempting to remove from an empty list.')
            
        removeItem = self._lastNode.data

        if self._firstNode is self._lastNode:
            self._firstNode = None
            self._lastNode = None
        else:
            current = self._firstNode
            while current.next is not self._lastNode:
                nextNode = current.next
                current = nextNode
            
            self._lastNode = current
            current.next = None
        return removeItem

    def InsertInTheMiddle(self, insertItem, idx):
        if idx <= 0 or self.isEmpty():
            self.InsertAtFront(insertItem)
            return
        else:
            current = self._firstNode
            while idx > 1:
                if current.next == None:
                    raise IndexError('Attempting to insert at index out of bound')
                nextNode = current.next
                current = nextNode
                idx = idx - 1
            # variable current is now the one before the one at idx
            if current is self._lastNode:
                self.InsertAtBack(insertItem)
                return
            else:
                newNode = DoublyLinkedListNode(insertItem, current.next, current) # next is current.next and prev is current
                current.next.prev = newNode # current.next is the one after newNode, setting its prev to newNode
                current.next = newNode
                
        return
    
    def removeInTheMiddle(self, idx):
        if self.isEmpty():
            raise IndexError('Attempting to remove from empty list')
        if idx <= 0:
            self.RemoveFromFront()
            return
        else:
            current = self._firstNode
            while idx > 1:
                if current.next == None:
                    raise IndexError('Attempting to insert at index out of bound')
                nextNode = current.next
                current = nextNode
                idx = idx - 1
            # variable current is now the one before the one at idx
            if current.next is self._lastNode:
                self.RemoveFromBack()
                return
            else:
                current.next = current.next.next
                current.next.prev = current
        return


class CircularDoublyLinkedList(DoublyLinkedList):
    _classname = 'CircularDoublyLinkedList'
    def __init__(self):
        super().__init__()

    def isEmpty(self):
        return self._firstNode == None
    
    def InsertAtFront(self,insertItem):
        if self.isEmpty():
            self._firstNode = DoublyLinkedListNode(insertItem)
            self._firstNode.next = self._firstNode
            self._firstNode.prev = self._firstNode
            self._lastNode = self._firstNode
        else:
            newNode = DoublyLinkedListNode(insertItem,self._firstNode,self._lastNode)
            self._firstNode.prev = newNode
            self._firstNode = newNode
            self._lastNode.next = newNode

    def InsertAtBack(self,insertItem):
        if self.isEmpty():
            self._firstNode = DoublyLinkedListNode(insertItem)
            self._firstNode.next = self._firstNode
            self._firstNode.prev = self._firstNode
            self._lastNode = self._firstNode
        else:
            newNode = DoublyLinkedListNode(insertItem,self._firstNode,self._lastNode) # Next is firstNode, Prev is lastNode
            self._lastNode.next = newNode
            self._firstNode.prev = newNode
            self._lastNode = newNode
            
    def RemoveFromFront(self):
        if self.isEmpty():
            raise IndexError('Attempting to remove from an empty list.')

        removeItem = self._firstNode.data

        if self._firstNode is self._lastNode:
            self._firstNode = None
            self._lastNode = None
        else:
            newfirst = self._firstNode.next
            self._firstNode = newfirst
            self._firstNode.prev = self._lastNode
            self._lastNode.next = self._firstNode

        return removeItem

    def RemoveFromBack(self):
        if self.isEmpty():
            raise IndexError('Attempting to remove from an empty list.')
            
        removeItem = self._lastNode.data

        if self._firstNode is self._lastNode:
            self._firstNode = None
            self._lastNode = None
        else:
            current = self._firstNode
            while current.next is not self._lastNode:
                nextNode = current.next
                current = nextNode
            self._lastNode = current
            self._firstNode.prev = self._lastNode
            self._lastNode.next = self._firstNode
        return removeItem

    def InsertInTheMiddle(self, insertItem, idx):
        if idx <= 0 or self.isEmpty():
            self.InsertAtFront(insertItem)
            return
        else:
            current = self._firstNode
            while idx > 1:
                if current.next == None:
                    raise IndexError('Attempting to insert at index out of bound')
                nextNode = current.next
                current = nextNode
                idx = idx - 1
            # variable current is now the one before the one at idx
            if current is self._lastNode:
                self.InsertAtBack(insertItem)
                return
            else:
                newNode = DoublyLinkedListNode(insertItem, current.next, current) # next is current.next and prev is current
                current.next.prev = newNode # current.next is the one after newNode, setting its prev to newNode
                current.next = newNode  
        return

class Stack(LinkedList):
    _classname = 'Stack'
    
    def __init__(self):
        super().__init__()
    
    def Push(self,dataValue):
        self.InsertAtFront(dataValue)
    
    def Pop(self):
        return self.RemoveFromFront()

if __name__ == '__main__':
    
    lst = LinkedList()
    print('New empty linked list')
    print(lst)
    
    print('Inserting 0 at front')
    lst.InsertAtFront(0)
    print(lst)
    
    print('Inserting 2 at back')
    lst.InsertAtBack(2)
    print(lst)
    
    print('Inserting 1 at index 1')
    lst.InsertInTheMiddle(1,1)
    print(lst)
    
    print('Inserting 3 to 7 at back')
    for i in range(3,8):
        lst.InsertAtBack(i)
        print (lst)
    
    print('1 is at index %1d'% (lst.search(1)))
    
    print('The list have a length of %1d'% (lst.count()))
    
    print('Removing from front')
    lst.RemoveFromFront()
    print(lst)
    
    print('Removing from back')
    lst.RemoveFromBack()
    print(lst)
    
    print('Removing at index 3')
    lst.removeInTheMiddle(3)
    print(lst)
    
    print('')
    
    
    
    
    lst = CircularLinkedList()
    print('New empty circular linked list')
    print(lst)
    
    print('Inserting 0 at front')
    lst.InsertAtFront(0)
    print(lst)
    
    print('Inserting 2 at back')
    lst.InsertAtBack(2)
    print(lst)
    
    print('Inserting 1 at index 1')
    lst.InsertInTheMiddle(1,1)
    print(lst)
    
    print('Inserting 3 to 7 at back')
    for i in range(3,8):
        lst.InsertAtBack(i)
        print (lst)
    
    print('1 is at index %1d'% (lst.search(1)))
    
    print('The list have a length of %1d'% (lst.count()))
    
    print('Removing from front')
    lst.RemoveFromFront()
    print(lst)
    
    print('Removing from back')
    lst.RemoveFromBack()
    print(lst)
    
    print('Removing at index 3')
    lst.removeInTheMiddle(3)
    print(lst)    
    
    print('Last node\'s next node have value of %1d'% (lst.lastNode.next.data))
    
    print('')
    
    

    
    lst = DoublyLinkedList()
    print('New empty doubly linked list')
    print(lst)
    
    print('Inserting 0 at front')
    lst.InsertAtFront(0)
    print(lst)
    
    print('Inserting 2 at back')
    lst.InsertAtBack(2)
    print(lst)
    
    print('Inserting 1 at index 1')
    lst.InsertInTheMiddle(1,1)
    print(lst)
    
    print('Inserting 3 to 7 at back')
    for i in range(3,8):
        lst.InsertAtBack(i)
        print (lst)
    
    print('1 is at index %1d'% (lst.search(1)))
    
    print('The list have a length of %1d'% (lst.count()))
    
    print('Removing from front')
    lst.RemoveFromFront()
    print(lst)
    
    print('Removing from back')
    lst.RemoveFromBack()
    print(lst)
    
    print('Last node\'s previous node have value of %1d'% (lst.lastNode.prev.data))

    print('Removing at index 3')
    lst.removeInTheMiddle(3)
    print(lst)
    
    print('')
    
    
    
    
    lst = CircularDoublyLinkedList()
    print('New empty circular linked list')
    print(lst)
    
    print('Inserting 0 at front')
    lst.InsertAtFront(0)
    print(lst)
    
    print('Inserting 2 at back')
    lst.InsertAtBack(2)
    print(lst)
    
    print('Inserting 1 at index 1')
    lst.InsertInTheMiddle(1,1)
    print(lst)
    
    print('Inserting 3 to 7 at back')
    for i in range(3,8):
        lst.InsertAtBack(i)
        print (lst)
    
    print('1 is at index %1d'% (lst.search(1)))
    
    print('The list have a length of %1d'% (lst.count()))
    
    print('Removing from front')
    lst.RemoveFromFront()
    print(lst)
    
    print('Removing from back')
    lst.RemoveFromBack()
    print(lst)
    
    print('Removing at index 3')
    lst.removeInTheMiddle(3)
    print(lst)    
    
    print('Last node\'s next node have value of %1d'% (lst.lastNode.next.data))
    
    print('First node\'s previous node have value of %1d'% (lst.firstNode.prev.data))
    
    print('')
    
    print('New empty stack')
    stak = Stack()
    aBoolean = True
    aCharacter = '$'
    anInteger = 34567
    aString = "hello"
    
    stak.Push( aBoolean );
    print(stak)
    stak.Push( aCharacter );
    print(stak)
    stak.Push( anInteger );
    print(stak)
    stak.Push( aString );
    print(stak)
    
    try:
        while(True):
            removedObject = stak.Pop()
            print(str(removedObject) + ' popped')
    except IndexError as err:
        print(err)
