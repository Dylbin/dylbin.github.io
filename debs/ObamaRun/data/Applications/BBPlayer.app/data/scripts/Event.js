let _eventsStorage = {};

class Event{
   
    static addListener(eventName, callback){
        if(_eventsStorage[eventName] === undefined){
            _eventsStorage[eventName] = [];
        }
        _eventsStorage[eventName].push( callback );
    }

    static removeListener(eventName, callback){
        let listeners = _eventsStorage[eventName];
        if(listeners !== undefined){
            let index = listeners.indexOf(callback);
            if( index >= 0){
                _eventsStorage[eventName].splice(index, 1);
            }
        }
    }

    static fire(eventName, value){
        let listeners = _eventsStorage[eventName];
        if(listeners !== undefined){
            // Using clonned version in case listeners get changed during loop
            const lst = listeners.slice(0);
            for(let i=0; i<lst.length; i++){
                lst[ i ](value);
            }
        }
    }
}