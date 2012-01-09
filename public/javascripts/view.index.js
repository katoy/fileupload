// Namespace for app utility methods.
var MF = {};

/**
 * Utility function to render the fact.
 * @param {Object} data
 */
MF.renderFact = function(data) {
    var id = data._id || null,
        fDate = data.ts || new Date(),
        d = new Date(fDate),
        strDate = d.toLocaleDateString() + ', ' + d.toLocaleTimeString(),
        fUser = data.author || 'anonymous',
        fBody = data.fact;

    return '' +
        '<div class="post">' +
            '<div class="hidden">' + id + '</div>' +
            '<div class="title">' +
                '<p>Posted on ' + strDate + ' by <a href="#">' + fUser + '</a></p>' +
            '</div>' +
            '<div class="entry">' +
                '<p>' + fBody + '</p>' +
            '</div>' +
            '<p class="links">' +
                '<a href="#" class="edit">Edit</a>' +
                '&nbsp;&nbsp;&nbsp;' +
                '<a href="#" class="delete">Delete</a>' +
            '</p>' +
        '</div>';
};

/**
 * Forces reload on facts list by clicking the matching list item.
 * @param {String} heroName
 */
MF.reloadList = function(heroName) {
    $('#new-fact-form').dialog('destroy');
    $('#heroes li a').filter(function() {
        return ($(this).text() == heroName);
    }).click();
};

/**
 * Configure and render a notification item.
 * @param {String} msg
 * @param {String} type (Optional, defaults to "notify")
 */
MF.notify = function(msg, type) {
    var delay = 4500;

    if (type === 'error') {
        $('<p>').text(msg).appendTo('#notification-list').asError().slideDown('slow');
    } else {
        $('<p>').text(msg).appendTo('#notification-list').asHighlight().slideDown('slow');
    }

    $('#notification-list div').each(function(idx, el) {
        $(el).delay(delay).slideUp('slow');
    });
};

/**
 * Lists all facts about a given hero.
 */
MF.listFacts = function() {
    var name = $(this).text() || $('#content h2').text();

    $('#content h2').text(name);
    $('#facts div').remove();
    $.getJSON('/hero/' + name, function(data) {
        for (var i = 0; i < data.length; i++) {
            // Render template.
            var tpl = MF.renderFact(data[i]);
            $(tpl).appendTo('#facts');
        }

        // Binding button events.
        $('.post').each(function(idx, el) {
            var id = $(el).find('.hidden').text(),
                hero = $('#content h2').text(),
                fact = $(el).find('.entry p').text();

            $('.edit', el).click(function() {
                $('#new-fact-form').dialog({
                    modal: true,
                    title: 'Edit fact'
                });

                $('#new-fact-form #fact-id').val(id);
                $('#new-fact-form #hero').val(hero);
                $('#new-fact-form #new-fact').val(fact);
                $('#add-new-fact').unbind('click');
                $('#add-new-fact').click(MF.editFact);

                return false;
            });

            $('.delete', el).click(function() {
                $('#dialog-confirm').dialog({
                    resizable: false,
                    height: 200,
                    modal: true,
                    title: 'Confirmation',
                    buttons: {
                        'Delete fact': function() {
                            $.ajax({
                                type: 'GET',
                                url: '/hero/delete-fact/' + id,
                                contentType: 'application/json; charset=utf-8',
                                dataType: 'json',

                                success: function() {
                                    var msg = 'Fact deleted successfully!';
                                    $('#new-fact-form').dialog('destroy');
                                    MF.notify(msg);
                                    MF.reloadList(hero);
                                },

                                error: function(err) {
                                    var msg = 'Status: ' + err.status + ': ' + err.responseText;
                                    $('#new-fact-form').dialog('destroy');
                                    MF.notify(msg, 'error');
                                    MF.reloadList(hero);
                                }
                            });


                            $(this).dialog('close');
                        },
                        'Cancel': function() {
                            $(this).dialog('close');
                        }
                    }
                });

                return false;
            });

        });

    });
    $('#content').show();

    return false;
};

/**
 * Adds a new fact about the selected hero.
 */
MF.addFact = function() {
    var name = $('#content h2').text(),
        fact = $('#new-fact').val();

    $.ajax({
        type: 'POST',
        url: '/hero/add-fact',
        data: JSON.stringify({ author: 'anonymous-form', hero: name, fact: fact }),
        contentType: 'application/json; charset=utf-8',
        dataType: 'json',

        success: function() {
            var msg = 'Fact created successfully!';
            $('#new-fact-form').dialog('destroy');
            MF.notify(msg);
            MF.reloadList(name);
        },

        error: function(err) {
            var msg = 'Status: ' + err.status + ': ' + err.responseText;
            $('#new-fact-form').dialog('destroy');
            MF.notify(msg, 'error');
            MF.reloadList(name);
        }
    });

    return false;
};

/**
 * Updates a given fact.
 */
MF.editFact = function() {
    var name = $('#content h2').text(),
        fact = $('#new-fact').val(),
        id = $('#fact-id').val();

    $.ajax({
        type: 'POST',
        url: '/hero/edit-fact',
        data: JSON.stringify({ id: id, author: 'anonymous-form', hero: name, fact: fact }),
        contentType: 'application/json; charset=utf-8',
        dataType: 'json',

        success: function() {
            var msg = 'Fact updated successfully!';

            MF.notify(msg);
            MF.reloadList(name);
        },

        error: function(err) {
            var msg = 'Status: ' + err.status + ': ' + err.responseText;
            $('#new-fact-form').dialog('destroy');
            MF.notify(msg);
            MF.reloadList(name);
        }
    });

    return false;
};

/**
 * Main entry point.
 */
$(function() {
    $.fn.asError = function() {
        return this.each(function() {
            $(this).replaceWith(function(i, html) {
                return '' +
                    '<div class="ui-state-error ui-corner-all" style="padding: 0 .7em;"><p>' +
                        '<span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>' +
                        html +
                    '</p></div>';
            });
        });
    };

    $.fn.asHighlight = function() {
        return this.each(function() {
            $(this).replaceWith(function(i, html) {
                return '' +
                    '<div class="ui-state-highlight ui-corner-all" style="padding: 0 .7em;"><p>' +
                        '<span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>' +
                        html +
                    '</p></div>';
            });
        });
    };

    // Initial state.
    $('#content').hide();
    // a workaround for a flaw in the demo system (http://dev.jqueryui.com/ticket/4375), ignore!
    $('#dialog:ui-dialog').dialog('destroy');


    $('#add-new-fact').button({disabled: true});
    $('#new-fact').bind('keyup', function(evt) {
        var noValue = (evt.target.value === ''),
            btn = $('#add-new-fact');

        btn.button('option', 'disabled', noValue);
    });

    // Binding event handlers.
    $('#heroes li a').click(MF.listFacts);

    $('#show-add')
        .button()
        .click(function() {
            $('#new-fact-form').dialog({
                modal: true,
                title: 'Add new fact'
            });

            $('#new-fact-form #hero').val($('#content h2').text());
            $('#new-fact-form #new-fact').val('');
            $('#add-new-fact').click(MF.addFact);

            return false;
        });

});
