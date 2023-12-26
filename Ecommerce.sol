// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract MarketplaceProducts{

string public storeName = "PKlegend32";
uint public count = 0;
//The product Details
    struct Product {
        uint id;
        string name;
        string description;
        bool sold;
        address payable owner;
        uint price;
        string category;
    }
    //The  Created Product Event
    event CreatedProduct ( string name,
        string description,
        bool sold,
        address payable owner,
        uint price,
        string category);

          //The  Buy Product Event
    event BuyProduct ( string name,
       
        bool sold,
        address payable owner,
        uint price
        );
       
       //List Of Products
    mapping (uint=>Product) public storeProducts;

//The Function that will create the product
    function createProduct(string  memory name,string memory description,uint price, string  memory category )public {

//Confirm the user send vaild Data

            require(price>0,"The Price Should be larger than 0");
            require(bytes(name).length>3,"The Name Should be larger than 3");
            require(bytes(description).length>10,"The description Should be larger than 10");
            require(bytes(category).length>1,"The category Should be larger than 1");

            count++;
            //ADD THE PRODUCT TO THE MAP LIST
            storeProducts[count]=Product(count,name,description,false, payable (msg.sender),price,category);

            emit CreatedProduct(name,description,false, payable (msg.sender),price,category);
      }

      //Create BUY PRODUCT FUNCTION

      function buyProduct(uint _id) public payable{
          Product memory singleProduct = storeProducts[_id];
          address payable seller = singleProduct.owner;
          //Validation
        require( !singleProduct.sold,"This Product Solded");
          require( seller!= msg.sender,"Can Not Buy your Product");

          require(msg.value >= singleProduct.price,"The mount u send  should be equal product price ");

          //Send the money to seller
          payable(seller).transfer(msg.value);
          singleProduct.owner = payable(msg.sender);
          singleProduct.sold =true;

          storeProducts[_id]=singleProduct;
          emit BuyProduct(singleProduct.name,true,payable(msg.sender),singleProduct.price);

      }
}