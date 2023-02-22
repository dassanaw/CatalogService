import ballerina/http;

service /Products on new http:Listener(8080) {

    isolated resource function post .(@http:Payload Product item) returns int|error? {
        return addProduct(item);
    }

}