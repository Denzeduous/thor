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
    list.length += 1;
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
    list.length += 1;
    return .NOERR;
}

removeAt :: proc(list: ^LinkedList($T), index: int) -> LinkedListError {
    list := list;

    if (index >= list.length) {
        return .OUT_OF_BOUNDS;
    }

    // We need to store the last node we visited for pointer swapping, hence previous
    node := list.first;
    previous: ^Node(T);

    // Iterate until we reach the end of the list, making sure the list itself is initialized
    for i := 0; i < index; i += 1 {
        if (node == nil) {
            return .EMPTY_LIST;
        }

        // You've reached your destination!
        if (i == index - 1) {

            // If it's the first node, change the first to the new value
            if (list.first == node) {
                list.first = node.next;
            }

            // If it's the last node, make sure to set the last to the new value
            if (list.last == node) {
                list.last = previous;
            }

            // Move the removed node's next pointer to the previous node's next pointer
            previous.next = node.next;
        }

        // If the value doesn't match, then iterate the node variables
        else {
            previous = node;
            node = node.next;
        }
    }

    return .NOERR;
}

get :: proc(list: ^LinkedList($T), index: int) -> (^Node(T), LinkedListError) {
    list := list;

    node := list.first;

    // Iterate until we either reach the index we want, or reach the end of the list
    for i := 0; i <= index; i += 1 {
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

    for i := 1; i <= 5; i += 1 {
        fmt.print(i);

        if (i != 5) {
            fmt.print(", ");
        }
    }

    fmt.println(']');

    removeAt(list, 2);

    fmt.print('[');

    for i := 0; i < 4; i += 1 {
        node, _ := get(list, i);
        fmt.print(node.value^);

        if (i != 3) {
            fmt.print(", ");
        }
    }

    fmt.println(']');
}