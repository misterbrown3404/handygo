<x-mail::message>
# {{ $title }}

{{ $messageBody }}

<x-mail::button :url="config('app.url')">
Visit HandyGo
</x-mail::button>

Thanks,<br>
{{ config('app.name') }} Team
</x-mail::message>
