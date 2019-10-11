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

insert :: proc(list: ^LinkedList($T), value: ^T) {
    list, value := list, value;

    node := new(Node(T));
    node.value = value;

    // Making sure the first value is initialized when it's empty
    if (list.first == nil) {
        list.first = node;
    }

    // If the last index isn't nil, make sure to set the last node's next pointer to the new node
    if (list.last != nil) {
        list.last.next = node;
    }

    // Setting the last index to the new node
    list.last = node;
}

insertAt :: proc (list: ^LinkedList($T), value: T, index: int) -> LinkedListError {
    list := list;
    previous: ^Node(T) = nil;
    node: ^Node(T) = list.first;
    newnode := Node{value=value};

    if (index == 0) {
        newnode.next = list.first;
        list.first = newnode;
        return .NOERR;
    }

    else if (index == list.length - 1) {
        list.last.next = newnode;
        list.last = newnode;
        return .NOERR;
    }

    if (list.first == nil) {
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

    if (previous == nil) {
        list.first = node.next;
    }

    else if (list.last == node) {
        list.last = previous;
    }

    else {
        previous.next = node.next;
    }

    return .NOERR;
}

get :: proc(list: ^LinkedList($T), index: int) -> (^Node(T), LinkedListError) {
    list := list;

    node: ^Node(T);

    // Iterate until we either reach the index we want, or reach the end of the list
    for i := 0; i < index; i += 1 {
        if (node == nil) {
            return nil, .OUT_OF_BOUNDS;
        }

        // You've found the node! Now return it!
        if (i == index) {
            return node, .NOERR;
        }

        // If it hasn't found the note, iterate the variables
        else {
            node = node.next;
        }
    }

    return nil, .EMPTY_LIST;
}

main :: proc() {
    list := new(LinkedList(int));

    value: ^int;

    for i := 1; i <= 5; i += 1 {
        value = new(int);
        value^ = i;
        insert(list, value);
    }

    fmt.print('[');

    for i := 0; i < 5; i += 1 {
        fmt.print(i);

        if (i != 4) {
            fmt.print(", ");
        }
    }

    fmt.println(']');

    err := removeAt(list, 2);
    fmt.println(err);

    fmt.print('[');

    for i := 0; i < 5; i += 1 {
        fmt.print(get(list, i));

        if (i != 4) {
            fmt.print(", ");
        }
    }

    fmt.println(']');
}