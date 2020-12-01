const MyGallery = artifacts.require("MyGallery");

const tSong = {
    title: "test-title",
    author: "test-author",
    category: 0,
    ismn: 1111111111111,
};

contract("MyGallery", () => {
    let contract = null;

    before(async () => {
        contract = await MyGallery.deployed();
    });

    it("should deploy smart contract", () => {
        assert.notEqual(contract.address, "");
    });

    it("should add a song", async () => {
        //Arrange
        let err = null;
        let song = null;

        //Act
        try{
            await contract.addSong(tSong.title, tSong.author, tSong.category, tSong.ismn);
        } catch(error) {
            err = error;
        }

        //Assert
        assert.isNull(err);
        assert.strictEqual(song.title, tSong.title);
        assert.strictEqual(song.author, tSong.author);
        assert.equal(Number(song.category), tSong.category);
        assert.equal(Number(song.ismn), tSong.ismn);
        assert.isTrue(song.available);
    });
});