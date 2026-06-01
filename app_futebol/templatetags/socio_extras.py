from django import template

register = template.Library()

@register.filter
def split(value, arg):
    return (value or '').split(arg)

@register.filter
def trim(value):
    return (value or '').strip()
