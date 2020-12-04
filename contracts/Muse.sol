// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

contract Muse {
    
    // ISMN begins from 1000000000000
    // 1 Ether = 1000000000000000000 Wei
    
    enum Category {
        Pop,
        Indie,
        Rock,
        HipHop,
        Mood,
        Chill,
        RnB,
        Romance,
        Jazz,
        Anime
    }

    /**The link is link for the song, 
    after user purchase only will show the passcode (havent do yet for customer logic) */
    struct Song {
        int256 ismn;
        bool exists;
        Description description;
        Details details;
    }

    struct Description {
        string title;
        string author;
        Category category;
    }
    
    struct Details {
        string link;
        string passcode;
        bool available;
        uint price;
        address payable owner;
    }

    struct Users {
        string userName;
        int256[] purchases;
        int256[] creations;
    }

    mapping(int256 => Song) private songs;
    Song[] private songList;

    mapping(address => Users) private users;

    /**Removed the ismn validation because it is auto generated,
    so no use for validate it, one error here is i cannot add validation le,
    else you will get "stack too deep" error, havent research on the solution */
    modifier validateAddSong(
        string memory title,
        string memory author,
        int256 category,
        string memory link
    ) {
        uint256 titleLength = bytes(title).length;
        require(titleLength > 0, "Title cannot be empty");

        uint256 authorLength = bytes(author).length;
        require(authorLength > 0, "Author cannot be empty");

        require(
            category == 0 ||
                category == 1 ||
                category == 2 ||
                category == 3 ||
                category == 4 ||
                category == 5 ||
                category == 6 ||
                category == 7 ||
                category == 8 ||
                category == 9,
            "Invalid category type"
        );

        uint256 linkLength = bytes(link).length;
        require(linkLength > 0, "Link cannot be empty");

        _;
    }

    modifier songExist(int256 ismn) {
        Song memory song = songs[ismn];
        require(song.exists, "Not found");

        _;
    }

    function addSong(
        string memory title,
        string memory author,
        int256 category,
        int256 ismn,
        string memory link,
        string memory passcode,
        uint price
    ) external validateAddSong(title, author, category, link) {
        
        Description memory description = toDescription(
            title,
            author,
            category
        );
        
        Details memory details = toDetails(
            link,
            passcode,
            price
        );
        
        Song memory newSong = toSong(
            ismn,
            description,
            details
        );

        songs[newSong.ismn] = newSong;
        songList.push(newSong);

        users[msg.sender].creations.push(newSong.ismn);
    }

    function toSong(int256 ismn, Description memory description, Details memory details) private pure returns (Song memory){
        return Song(
            ismn,
            true,
            description,  
            details  
        );
    }

    function toDescription(string memory title, string memory author, int256 category) private pure returns (Description memory){
        return Description(
            title,
            author,
            mapCategoryType(category)
        );
    }
    
    function toDetails(string memory link, string memory passcode, uint price) private view returns (Details memory){
        return Details(
            link,
            passcode,
            true,
            price,
            msg.sender
        );
    }

    function getSong(int256 ismn) public view songExist(ismn) returns (Song memory){
        return songs[ismn];
    }

    function deleteSong(int256 ismn) external songExist(ismn) {
        delete songs[ismn];

        for (uint256 i = 0; i < songList.length; i++) {
            Song memory song = songList[i];

            if (song.ismn == ismn) {
                songList[i] = songList[songList.length - 1];
                songList.pop();
                break;
            }
        }

        int256[] storage userCreations = users[msg.sender].creations;

        for (uint256 i = 0; i < userCreations.length; i++) {
            if (userCreations[i] == ismn) {
                userCreations[i] = userCreations[userCreations.length - 1];
                userCreations.pop();
                break;
            }
        }
    }

    // // *Purchase Song*
    // function issueSong(int256 ismn) external songExist(ismn) {
    //     songs[ismn].available = false;
    //     setListedSongAvailability(ismn, false);
    //     user[msg.sender].songPurchased.push(songs[ismn]);
    // }

    // // *Return Song*
    // function returnSong(int256 ismn) external songExist(ismn) {
    //     songs[ismn].available = true;
    //     setListedSongAvailability(ismn, true);
    // }

    function getSongCount() external view returns (uint256) {
        return songList.length;
    }

    function getAllSongs() external view returns (Song[] memory) {
        return songList;
    }

    /**Display the purchased song for this user */
    function getPurchasedSongs() external view returns (int256[] memory) {
        return users[msg.sender].purchases;
    }

    function getPurchasedSongCount() external view returns (uint256) {
        return users[msg.sender].purchases.length;
    }

    /**Display the created song for this user */
    function getCreatedSongs() external view returns (int256[] memory) {
        return users[msg.sender].creations;
    }

    function getCreatedSongCount() external view returns (uint256) {
        return users[msg.sender].creations.length;
    }

    function mapCategoryType(int256 category) private pure returns (Category) {
        if (category == 0) {
            return Category.Pop;
        }

        if (category == 1) {
            return Category.Indie;
        }

        if (category == 2) {
            return Category.Rock;
        }

        if (category == 3) {
            return Category.HipHop;
        }

        if (category == 4) {
            return Category.Mood;
        }

        if (category == 5) {
            return Category.Chill;
        }

        if (category == 6) {
            return Category.RnB;
        }

        if (category == 7) {
            return Category.Romance;
        }

        if (category == 8) {
            return Category.Jazz;
        }

        if (category == 9) {
            return Category.Anime;
        }

        revert("Invalid category type");
    }

    function setListedSongAvailability(int256 ismn, bool available) private {
        for (uint256 i = 0; i < songList.length; i++) {
            if (songList[i].ismn == ismn) {
                songList[i].details.available = available;
                break;
            }
        }
    }
    
    // Muse customer
    
    function addPurchase(int256 ismn) payable public validatePurchase(ismn) {
        int256[] storage purchaseList = users[msg.sender].purchases;
        
        Song memory song = getSong(ismn);
        
        makePayment(song.details.owner, song.details.price);
        
        purchaseList.push(ismn);
    }
    
    function makePayment(address payable artistAddress, uint price) private validatePayment(price) {
        artistAddress.transfer(price);
    }
    
    // Check if message.value is more than price.
    modifier validatePayment(uint price) {
        require(msg.value >= price, "Payment is insufficient!");
        _;
    }
    
    // Check if buyer is eligible for purchase.
    modifier validatePurchase(int256 ismn) {
        require(!isPurchased(ismn), "Song already purchased!");
        _;
    }
    
    function isPurchased(int256 ismn) private view returns(bool){
        int256[] memory purchaseList = users[msg.sender].purchases;
        
        for(uint256 i = 0; i < purchaseList.length; i++) {
            if (purchaseList[i] == ismn) {
                return true;
            }
        }
        return false;
    }
}
