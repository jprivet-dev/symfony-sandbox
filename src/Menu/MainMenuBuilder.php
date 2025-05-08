<?php

namespace App\Menu;

use Knp\Menu\FactoryInterface;
use Knp\Menu\ItemInterface;

class MainMenuBuilder
{
    private $factory;

    /**
     * Add any other dependency you need...
     */
    public function __construct(FactoryInterface $factory)
    {
        $this->factory = $factory;
    }

    public function createMainMenu(array $options): ItemInterface
    {
        $menu = $this->factory->createItem('root');

        $menu->addChild('Blog', ['route' => 'app_blog']);
        $menu->addChild('Tags', ['route' => 'app_tags']);
        $menu->addChild('Projects', ['route' => 'app_projects']);
        $menu->addChild('About', ['route' => 'app_about']);

        return $menu;
    }
}
