
import ballerinax/mysql;
import ballerinax/mysql.driver as _; // This bundles the driver to the project so that you don't need to bundle it via the `Ballerina.toml` file.
import ballerina/sql;

# Description
#
# + id - Field Description  
# + name - Field Description  
# + description - Field Description  
# + intendedFor - Field Description  
# + includes - Field Description  
# + price - Field Description  
# + color - Field Description  
# + material - Field Description  
# + displayPrice - Field Description

# The Product domain object.
public type Product record {|
    string id;
    string name;
    string description;
    string intendedFor;
    string includes;
    string price;
    string color;
    string material;
    string displayPrice;
|};

configurable string USER = ?;
configurable string PASSWORD = ?;
configurable string HOST = ?;
configurable int PORT = ?;
configurable string DATABASE = ?;

final mysql:Client dbClient = check new(
    host=HOST, user=USER, password=PASSWORD, port=PORT, database=DATABASE
);

isolated function addProduct(Product item) returns int|error {
    sql:ExecutionResult result = check dbClient->execute(`
        INSERT INTO catalog (id, name, description, intendedFor, includes,
                               price, color, material, displayPrice)
        VALUES (${item.id}, ${item.name}, ${item.description},  
                ${item.intendedFor}, ${item.includes}, ${item.price}, ${item.color},
                ${item.material}, ${item.displayPrice})
    `);

    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID");
    }

}

isolated function getProduct(string id) returns Product|error {
    Product item = check dbClient->queryRow(
        `SELECT * FROM catalog WHERE id = ${id}`
    );
    return item;
}

isolated function getAllProducts() returns Product[]|error {
    Product[] products = [];
    stream<Product, error?> resultStream = dbClient->query(
        `SELECT * FROM catalog`
    );
    check from Product product in resultStream
        do {
            products.push(product);
        };
    check resultStream.close();
    return products;
}