// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

contract MyGallery {
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
        string title;
        string author;
        Category category;
        int256 ismn;
        string link;
        string passcode;
        bool available;
        bool exists;
    }

    struct Users {
        string userName;
        Song[] songCreated;
        Song[] songPurchased;
    }

    mapping(int256 => Song) private songs;
    Song[] private songList;
    mapping(address => Users) private user;

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
        string memory passcode
    ) external validateAddSong(title, author, category, link) {
        Song memory newSong = Song(
            title,
            author,
            mapCategoryType(category),
            ismn,
            link,
            passcode,
            true,
            true
        );

        songs[ismn] = newSong;
        songList.push(newSong);

        user[msg.sender].songCreated.push(newSong);
    }

    function getSong(int256 ismn)
        external
        view
        songExist(ismn)
        returns (Song memory)
    {
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

        for (uint256 i = 0; i < user[msg.sender].songCreated.length; i++) {
            Song memory song = user[msg.sender].songCreated[i];

            if (song.ismn == ismn) {
                user[msg.sender].songCreated[i] = user[msg.sender]
                    .songCreated[user[msg.sender].songCreated.length - 1];
                user[msg.sender].songCreated.pop();
                break;
            }
        }
    }

    // *Purchase Song*
    function issueSong(int256 ismn) external songExist(ismn) {
        songs[ismn].available = false;
        setListedSongAvailability(ismn, false);
        user[msg.sender].songPurchased.push(songs[ismn]);
    }

    // *Return Song*
    function returnSong(int256 ismn) external songExist(ismn) {
        songs[ismn].available = true;
        setListedSongAvailability(ismn, true);
    }

    function getSongCount() external view returns (uint256) {
        return songList.length;
    }

    function getAllSongs() external view returns (Song[] memory) {
        return songList;
    }

    /**Display only the purchased song for this user */
    function getPurchasedSongs() external view returns (Song[] memory) {
        return user[msg.sender].songPurchased;
    }

    function getPurchasedSongCount() external view returns (uint256) {
        return user[msg.sender].songPurchased.length;
    }

    /**Display  the created song for this user */
    function getCreatedSongs() external view returns (Song[] memory) {
        return user[msg.sender].songCreated;
    }

    function getCreatedSongCount() external view returns (uint256) {
        return user[msg.sender].songCreated.length;
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
                songList[i].available = available;
                break;
            }
        }
    }
}
