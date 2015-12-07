<?php

/**
 * Created by PhpStorm.
 * User: roman
 * Date: 07.12.15
 * Time: 16:32
 */
class Php7_Fix_Model_Layout extends Mage_Core_Model_Layout
{
    /**
     * override to use with php7
     */
    public function getOutput()
    {
        $out = '';
        if (!empty($this->_output)) {
            foreach ($this->_output as $callback) {
                $functionName = $callback[1];
                $out .= $this->getBlock($callback[0])->$functionName();
            }
        }

        return $out;
    }
}