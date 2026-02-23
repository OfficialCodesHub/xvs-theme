{{-- ========================================
     XVS Theme Wrapper for Pterodactyl
     Arix-Inspired Modern UI
     ======================================== --}}

<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    
    <title>@yield('title') - {{ config('app.name', 'Pterodactyl') }}</title>
    
    <!-- XVS Theme Styles -->
    <link href="{{ asset('themes/xvs/css/xvs-theme.css') }}" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    @stack('styles')
</head>
<body class="dark:bg-gray-900">
    <div id="app">
        <!-- Sidebar -->
        <aside class="sidebar fixed left-0 top-0 h-screen w-64 bg-gray-800 dark:bg-gray-800">
            <div class="flex items-center justify-center h-16 border-b border-gray-700 dark:border-gray-700">
                <h1 class="text-xl font-bold bg-gradient-to-r from-indigo-400 to-purple-400 bg-clip-text text-transparent">
                    {{ config('app.name', 'Panel') }}
                </h1>
            </div>
            
            <nav class="mt-6">
                <a href="{{ route('index') }}" class="flex items-center px-6 py-3 text-gray-300 hover:text-white hover:bg-gray-700 dark:hover:bg-gray-700 transition-colors">
                    <i class="fas fa-home w-5 h-5 mr-3"></i>
                    <span>Dashboard</span>
                </a>
                
                <a href="{{ route('server.index') }}" class="flex items-center px-6 py-3 text-gray-300 hover:text-white hover:bg-gray-700 dark:hover:bg-gray-700 transition-colors">
                    <i class="fas fa-server w-5 h-5 mr-3"></i>
                    <span>Servers</span>
                </a>
                
                <a href="{{ route('account') }}" class="flex items-center px-6 py-3 text-gray-300 hover:text-white hover:bg-gray-700 dark:hover:bg-gray-700 transition-colors">
                    <i class="fas fa-user w-5 h-5 mr-3"></i>
                    <span>Account</span>
                </a>
                
                @admin
                <div class="border-t border-gray-700 dark:border-gray-700 my-4"></div>
                
                <a href="{{ route('admin.index') }}" class="flex items-center px-6 py-3 text-gray-300 hover:text-white hover:bg-gray-700 dark:hover:bg-gray-700 transition-colors">
                    <i class="fas fa-cog w-5 h-5 mr-3"></i>
                    <span>Administration</span>
                </a>
                @endadmin
            </nav>
            
            <!-- User Menu -->
            <div class="absolute bottom-0 w-64 p-4 border-t border-gray-700 dark:border-gray-700">
                <div class="flex items-center">
                    <img src="https://www.gravatar.com/avatar/{{ md5(Auth::user()->email ?? '') }}?s=40&d=mp" 
                         alt="Avatar" 
                         class="w-8 h-8 rounded-full">
                    <div class="ml-3">
                        <p class="text-sm font-medium text-white">{{ Auth::user()->name ?? 'Guest' }}</p>
                        <p class="text-xs text-gray-400">{{ Auth::user()->email ?? '' }}</p>
                    </div>
                </div>
            </div>
        </aside>
        
        <!-- Main Content -->
        <main class="ml-64 p-8 min-h-screen bg-gray-900 dark:bg-gray-900">
            @yield('content')
        </main>
    </div>
    
    <!-- Scripts -->
    <script src="{{ asset('js/app.js') }}" defer></script>
    @stack('scripts')
</body>
</html>
