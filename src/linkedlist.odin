package LinkedList;

Node :: struct {
    value: rawptr,
    next: ^Node,
}

LinkedList :: struct {
    first: ^Node,
    last: ^Node,
    length: int,
}

LinkedListError :: enum {
    NOERR,
    OUT_OF_BOUNDS,
    EMPTY_LIST,
}

NodeErrorPackage :: union {
    Node,
    LinkedListError,
}

insert :: proc(list: LinkedList, value: rawptr) {
    nextnode: Node = Node{value=value};

    if (list.first == nil) {
        list.first = nextnode;
        list.last = nextnode;
        return;
    }

    list.last.next = &nextnode;
}

insertAt :: proc (list: LinkedList, value: rawptr, index: int) -> LinkedListError {
    previous: Node = nil;
    node: Node = list.first;
    newnode := Node{value=value};

    if (index == 0) {
        newnode.next = list.start;
        list.start = newnode;
        return LinkedListError.NOERR;
    }

    else if (index == list.length - 1) {
        list.last.next = newnode;
        list.last = newnode;
        return LinkedListError.NOERR;
    }

    if (list.start == nil) {
        return LinkedListError.EMPTY_LIST;
    }

    for i = 0; i < index; i += 1 {
        if (node == nil) {
            return LinkedListError.OUT_OF_BOUNDS;
        }

        previous = node;
        node = node.next;
    }

    previous.next = &newnode;
    newnode.next = &node;

    return LinkedListError.NOERR;
}

removeAt :: proc(list: LinkedList, index: int) -> LinkedListError {
    previous: Node = nil;
    node: Node = list.first;

    for i := 0; i < index; i += 1 {
        if (node == nil) {
            return LinkedListError.OUT_OF_BOUNDS;
        }

        previous = node;
        node = node.next;
    }

    node.next = &previous.next;
    previous.next = &node;
}

get :: proc(list: LinkedList, index: int) -> NodeErrorPackage {
    node: Node = list.first;

    for i = 0; i < index; i += 1 {
        if (node == nil) {
            return LinkedListError.OUT_OF_BOUNDS;
        }

        node = node.next;
    }

    return node;
}

main :: proc() {
    list := LinkedList{};

    value: rawptr = alloc(4);
    ^value = 1;
    insert(list, value);

    value = alloc(4);
    ^value = 2;
    insert(list, value);

    value = alloc(4);
    ^value = 3;
    insert(list, value);

    value = alloc(4);
    ^value = 4;
    insert(list, value);

    value = alloc(4);
    ^value = 5;
    insert(list, value);

    for i := 0; i < 5; i += 1 {
       fmt.println(i); 
    }

    removeAt(list, 2);
}