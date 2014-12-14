var config = {
    settings:{showPopoutIcon:false},
    dimensions:{borderWidth: 20},
    content: [{
        type: 'row',
        content:[{
            type: 'stack',
            width: 30,
            activeItemIndex: 0,
            content:[{
                type: 'component',
                componentName: 'testComponent',
                title:'Component 1'
            },{
                type: 'component',
                componentName: 'testComponent',
                title:'Component 2'
            }]
        },{
            type: 'column',
            content:[{
                type: 'component',
                componentName: 'bbc_Tab'
            },{
                type: 'component',
                componentName: 'google_Tab'
            }]
        }]
    }]
};

var BBC_Tab = function( container, state ) {
    this.element = $("<iframe src='http://news.bbc.co.uk' width='100%' height='100%' />")
    this.container = container;
    this.container.getElement().append( this.element );
}

var Google_Tab = function( container, state ) {
    this.element = $("<iframe src='https://www.google.co.uk' width='100%' height='100%' />")
    //this.element = $("<iframe src='https://www.github.com' width='100%' height='100%' />")
    this.container = container;
    this.container.getElement().append( this.element );
}
var TestComponent = function( container, state ) {
    this.element = $(
        '<table class="test">' +
        '<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>' +
        '<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>' +
        '<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>' +
        '<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>' +
        '<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>' +
        '</table>'
    );

    this.tds = this.element.find( 'td' );
    this.tds.click( this._highlight.bind( this ) );
    this.container = container;
    this.container.getElement().append( this.element );

    if( state.tiles ) {
        this._applyState( state.tiles );
    }
};

TestComponent.prototype._highlight = function( e ) {
    $( e.target ).toggleClass( 'active' );
    this._serialize();
};

TestComponent.prototype._serialize = function() {
    var state = '',
        i;

    for( i = 0; i < this.tds.length; i++ ) {
        state += $( this.tds[ i ] ).hasClass( 'active' ) ? '1' : '0';
    }

    this.container.extendState({ tiles: state });
};

TestComponent.prototype._applyState = function( state ) {
    for( var i = 0; i < this.tds.length; i++ ) {
        if( state[ i ] === '1' ){
            $( this.tds[ i ] ).addClass( 'active' );
        }
    }
};


$(function(){
    var createLayout = function( config, container ) {
        layout = new GoldenLayout( config, $(container) );
        layout.registerComponent( 'testComponent', TestComponent );
        layout.registerComponent( 'bbc_Tab', BBC_Tab );
        layout.registerComponent( 'google_Tab', Google_Tab );
        layout.init();
        return layout;
    };

    layoutA = createLayout( config, '.layoutA' );


    $(window).resize(function(){
        layoutA.updateSize();
    });
});