// Only used in QA builds, refer to SPTInAppMessageCardMessageViewModel.m

var primaryButton = document.querySelector('[data-click-to-action-id="primaryCta"]');
var fullScreenDismissButton = document.querySelector('[data-click-to-action-id="dismissCta"]');
var legalLink = document.querySelector('[data-click-to-action-id="legalCta"]');

// Card Modal
var title = document.querySelector('.CardModal-title');
var message = document.querySelector('.CardModal-message');
var legal = document.querySelector('.CardModal-legal');

// FullScreen
var fullScreenHeader = document.querySelector('.CardFullscreen-title');
var fullScreenMessage = document.querySelector('.CardFullscreen-message');
var fullScreenLegal = document.querySelector('.CardFullscreen-legal');
var fullScreenDismissButtonText = document.querySelector('.CardFullscreen-close');

function clickPrimaryButton() {
    var event = new MouseEvent('click', {
                               view: window,
                               bubbles: true,
                               cancelable: true
                               });

    primaryButton.dispatchEvent(event);
}

function clickLegalLink() {
    var event = new MouseEvent('click', {
                               view: window,
                               bubbles: true,
                               cancelable: true
                               });

    legalLink.dispatchEvent(event);
}

function clickFullScreenDismissButton() {
    var event = new MouseEvent('click', {
                               view: window,
                               bubbles: true,
                               cancelable: true
                               });

    fullScreenDismissButton.dispatchEvent(event);
}

function getPrimaryButtonText() {
    return primaryButton.innerText;
}

function getLegalText() {
    return legal.innerText;
}

function getInAppMessageTitleText() {
    return title.innerText;
}

function getMessageText() {
    return message.innerText;
}

// FullScreen actions
function getFullScreenHeaderText() {
    return fullScreenHeader.innerText;
}

function getFullscreenMessageText() {
    return fullScreenMessage.innerText;
}

function getFullScreenLegalText() {
    return fullScreenLegal.innerText;
}

function getFullscreenDismissText() {
    return fullScreenDismissButtonText.innerText;
}
