package LinkedList;

import "core:fmt"

Node :: struct(T: typeid) {
    value: ^T,
    next: ^Node(T),
}

LinkedList :: struct(T: typeid) {
    first: ^Node(T),
    last: ^Node(T),
    length: int,
}

LinkedListError :: enum {
    NOERR,
    OUT_OF_BOUNDS,
    EMPTY_LIST,
}

insert :: proc(list: ^LinkedList($T), value: ^$K) {
    list, value := list, value;
    newnode: ^Node(T) = new(Node(T));
    newnode.value = value;

    if (list.first == nil) {
        list.first = newnode;
        list.last = newnode;
        return;
    }

    list.last.next = newnode;
}

insertAt :: proc (list: ^LinkedList($T), value: $K, index: int) -> LinkedListError {
    list := list;
    previous: ^Node(T) = nil;
    node: ^Node(T) = list.first;
    newnode := Node{value=value};

    if (index == 0) {
        newnode.next = list.start;
        list.start = newnode;
        return .NOERR;
    }

    else if (index == list.length - 1) {
        list.last.next = newnode;
        list.last = newnode;
        return .NOERR;
    }

    if (list.start == nil) {
        return .EMPTY_LIST;
    }

    for i = 0; i < index; i += 1 {
        if (node == nil) {
            return .OUT_OF_BOUNDS;
        }

        previous = node;
        node = node.next;
    }

    previous.next = newnode;
    newnode.next = node;

    return .NOERR;
}

removeAt :: proc(list: ^LinkedList($T), index: int) -> LinkedListError {
    list := list;
    previous: ^Node(T) = nil;
    node: ^Node(T) = list.first;

    for i := 0; i < index; i += 1 {
        if (node == nil) {
            return .OUT_OF_BOUNDS;
        }

        previous = node;
        node = node.next;
    }

    node.next = previous.next;
    previous.next = node;
    return .NOERR;
}

get :: proc(list: ^LinkedList($T), index: int) -> (^Node($K), LinkedListError) {
    list := list;
    node: ^Node(T) = list.first;

    for i := 0; i < index; i += 1 {
        if (node == nil) {
            return nil, .OUT_OF_BOUNDS;
        }

        node = node.next;
    }

    return node, .NOERR;
}

main :: proc() {
    list := new(LinkedList(int));

    value := new(int);
    value^ = 1;
    insert(list, value);

    value = new(int);
    value^ = 1;
    insert(list, value);

    value = new(int);
    value^ = 1;
    insert(list, value);

    value = new(int);
    value^ = 1;
    insert(list, value);

    value = new(int);
    value^ = 1;
    insert(list, value);

    for i := 0; i < 5; i += 1 {
       fmt.println(i); 
    }

    removeAt(list, 2);
}