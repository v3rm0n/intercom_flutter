# intercom_flutter_web

The web implementation of [`intercom_flutter`][1].

## Usage

This package is already included as part of the `intercom_flutter` package dependency, and will be included when using `intercom_flutter` as normal.

But if you want to use this package as alone, first add the dependency `intercom_flutter_web` and then add the below script inside body tag in the index.html file located under web folder
```html
<script>
    window.intercomSettings = {
        hide_default_launcher: true, // set this to false, if you want to show the default launcher
    };
    (function(){var w=window;var ic=w.Intercom;if(typeof ic==="function"){ic('reattach_activator');ic('update',w.intercomSettings);}else{var d=document;var i=function(){i.c(arguments);};i.q=[];i.c=function(args){i.q.push(args);};w.Intercom=i;var l=function(){var s=d.createElement('script');s.type='text/javascript';s.async=true;s.src='https://widget.intercom.io/widget/';var x=d.getElementsByTagName('script')[0];x.parentNode.insertBefore(s, x);};if(document.readyState==='complete'){l();}else if(w.attachEvent){w.attachEvent('onload',l);}else{w.addEventListener('load',l,false);}}})();

</script>
```
#### Following functions are not yet supported on Web:

- unreadConversationCount
- setInAppMessagesVisibility
- displayHelpCenter
- sendTokenToIntercom
- handlePushMessage
- isIntercomPush
- handlePush

[1]: ../intercom_flutter

