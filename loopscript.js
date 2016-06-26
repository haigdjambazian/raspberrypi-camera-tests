    var currentImageIndex = -1,
        maxImageIndex = 0,
        images = [],
        changeInterval = 150;

    // prepares relevant variables to cycle throguh images
    var setUp = function() {
        images = document.images;
        maxImageIndex = images.length;
        currentImageIndex = 0;
    };

    // changes the banner currently being displayed
    var changeBanner = function() {
        var i;

        // either re-set the index to 0 if the max length was reached or increase the index by 1
        currentImageIndex = (currentImageIndex >= maxImageIndex - 1) ? 0 : currentImageIndex += 1;

        document.getElementById("mainimg").src = images[currentImageIndex].src

        // for (i = 0; i < maxImageIndex; i += 1) { images[i].hidden = (i !== currentImageIndex); }
    };

    // a function which is triggered following the `load` event
    window.onload = function() {
        setUp();

        document.getElementById("mainimg").src = images[currentImageIndex].src

        // images[currentImageIndex].hidden = false; // show the first banner image;

        setInterval(changeBanner, changeInterval); // following a delay, keep changing the banner image by the specified interval
    };
